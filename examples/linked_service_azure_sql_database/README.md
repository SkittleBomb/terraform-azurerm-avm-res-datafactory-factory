<!-- BEGIN_TF_DOCS -->
# Linked Service Azure Data Lake Storage Gen2 Account example

Manages a Linked Service (connection) between Data Lake Storage Gen2 and Azure Data Factory.

```hcl
terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# We need the tenant id.
data "azurerm_client_config" "this" {}

## Section to provide a random Azure region for the resource group
# This allows us to randomize the region for the resource group.
module "regions" {
  source  = "Azure/regions/azurerm"
  version = ">= 0.3.0"
}

# This allows us to randomize the region for the resource group.
resource "random_integer" "region_index" {
  max = length(module.regions.regions) - 1
  min = 0
}
## End of section to provide a random Azure region for the resource group

# This ensures we have unique CAF compliant names for our resources.
module "naming" {
  source  = "Azure/naming/azurerm"
  version = ">= 0.3.0"
}

# This is required for resource modules
resource "azurerm_resource_group" "this" {
  location = module.regions.regions[random_integer.region_index.result].name
  name     = module.naming.resource_group.name_unique
}

# A vnet is required for the storage account
resource "azurerm_virtual_network" "this" {
  name                = module.naming.virtual_network.name_unique
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "this" {
  name                 = module.naming.subnet.name_unique
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.0.1.0/24"]

  service_endpoints = ["Microsoft.Storage"]
}

resource "azurerm_private_dns_zone" "blob" {
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = azurerm_resource_group.this.name
}

resource "azurerm_private_dns_zone" "datafactory" {
  name                = "privatelink.datafactory.azure.net"
  resource_group_name = azurerm_resource_group.this.name
}


module "storage_account" {
  source = "git::https://github.com/SkittleBomb/terraform-azurerm-res-storage-storageaccount.git?ref=main"

  name                = module.naming.storage_account.name_unique
  resource_group_name = azurerm_resource_group.this.name

  account_tier                      = "Standard"  # (Optional) Defines the Tier to use for this storage account. Valid options are Standard and Premium. Defaults to Standard.
  account_replication_type          = "GRS"       # (Optional) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, and RAGZRS. Defaults to LRS.
  account_kind                      = "StorageV2" # (Optional) Defines the Kind to use for this storage account. Valid options are Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage. Defaults to StorageV2.
  access_tier                       = "Hot"       # (Optional) Defines the access tier to use for this storage account. Valid options are Hot and Cool. Defaults to Hot.
  is_hns_enabled                    = true        # (Optional) Defines whether or not Hierarchical Namespace is enabled for this storage account. Defaults to false
  public_network_access_enabled     = true        # (Optional) Defines whether or not public network access is allowed for this storage account. Defaults to false.
  shared_access_key_enabled         = true        # (Optional) Defines whether or not shared access key is enabled for this storage account. Defaults to false.
  infrastructure_encryption_enabled = false       # (Optional) Defines whether or not infrastructure encryption is enabled for this storage account. Defaults to false.
  default_to_oauth_authentication   = true

  network_rules = {
    default_action             = "Deny"                   # (Required) Defines the default action for network rules. Valid options are Allow and Deny.
    ip_rules                   = []                       # (Optional) Defines the list of IP rules to apply to the storage account. Defaults to [].
    virtual_network_subnet_ids = [azurerm_subnet.this.id] # (Optional) Defines the list of virtual network subnet IDs to apply to the storage account. Defaults to [].
    bypass                     = ["AzureServices"]        # (Optional) Defines which traffic can bypass the network rules. Valid options are AzureServices and None. Defaults to [].
    private_link_access = [
      {
        endpoint_resource_id = module.data_factory.resource.id
      }
    ]
  }

  private_endpoints = {
    blob = {
      subresource_name              = "blob"
      private_dns_zone_resource_ids = [azurerm_private_dns_zone.blob.id]
      subnet_resource_id            = azurerm_subnet.this.id
    }
  }
  role_assignments = {
    storage_account_contributor = {
      principal_id               = module.data_factory.resource.identity[0].principal_id
      role_definition_id_or_name = "Storage Account Contributor"
    }
  }

  tags = {
    environment = "staging"
  }
}

# Create a key vault
module "keyvault" {
  source              = "Azure/avm-res-keyvault-vault/azurerm"
  name                = module.naming.key_vault.name_unique
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tenant_id           = data.azurerm_client_config.this.tenant_id

}



# This is the module call
module "data_factory" {
  source = "../../"

  name                = module.naming.data_factory.name_unique
  resource_group_name = azurerm_resource_group.this.name

  public_network_enabled = false

  private_endpoints = {
    data_factory = {
      subresource_name              = "dataFactory"
      private_dns_zone_resource_ids = [azurerm_private_dns_zone.datafactory.id]
      subnet_resource_id            = azurerm_subnet.this.id
      location                      = azurerm_resource_group.this.location
    },
    portal = {
      subresource_name              = "portal"
      private_dns_zone_resource_ids = [azurerm_private_dns_zone.datafactory.id]
      subnet_resource_id            = azurerm_subnet.this.id
      location                      = azurerm_resource_group.this.location
    },
  }

  identity = {
    type         = "SystemAssigned"
    identity_ids = []
  }

  linked_service_data_lake_storage_gen2 = {
    data_lake_storage1 = {
      name                 = "TestlinkedServiceDataLakeStorageGen2"
      data_factory_id      = module.data_factory.resource.id
      url                  = module.storage_account.resource.primary_dfs_endpoint
      use_managed_identity = true

    }
  }
  tags = {
    environment = "test"
    function    = "datafactory"
  }

}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.3.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.7.0, < 4.0.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0, < 4.0.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.7.0, < 4.0.0)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.5.0, < 4.0.0)

## Resources

The following resources are used by this module:

- [azurerm_private_dns_zone.blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) (resource)
- [azurerm_private_dns_zone.datafactory](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) (resource)
- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [random_integer.region_index](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) (resource)
- [azurerm_client_config.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

No optional inputs.

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_data_factory"></a> [data\_factory](#module\_data\_factory)

Source: ../../

Version:

### <a name="module_keyvault"></a> [keyvault](#module\_keyvault)

Source: Azure/avm-res-keyvault-vault/azurerm

Version:

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version: >= 0.3.0

### <a name="module_regions"></a> [regions](#module\_regions)

Source: Azure/regions/azurerm

Version: >= 0.3.0

### <a name="module_storage_account"></a> [storage\_account](#module\_storage\_account)

Source: git::https://github.com/SkittleBomb/terraform-azurerm-res-storage-storageaccount.git

Version: main

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->