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
  account_replication_type          = "LRS"       # (Optional) Defines the type of replication to use for this storage account. Valid options are LRS, GRS, RAGRS, ZRS, GZRS, and RAGZRS. Defaults to LRS.
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

  source                        = "Azure/avm-res-keyvault-vault/azurerm"
  name                          = module.naming.key_vault.name_unique
  enable_telemetry              = false
  location                      = azurerm_resource_group.this.location
  resource_group_name           = azurerm_resource_group.this.name
  tenant_id                     = data.azurerm_client_config.this.tenant_id
  sku_name                      = "standard"
  public_network_access_enabled = false
  network_acls = {
    bypass         = "AzureServices"
    default_action = "Deny"
  }

  role_assignments = {
    key_vault_contributor = {
      principal_id               = module.data_factory.resource.identity[0].principal_id
      role_definition_id_or_name = "Key Vault Secrets Officer"
    },
    key_vault_contributor2 = {
      principal_id               = "66b1395c-32a9-4063-b90f-437cb427a9bb"
      role_definition_id_or_name = "Key Vault Secrets Officer"
    }
  }

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

  linked_service_key_vault = {
    key_vault1 = {
      name            = "TestKeyVaultLinkedService"
      data_factory_id = module.data_factory.resource.id
      key_vault_id    = module.keyvault.resource.id
    }
  }

  linked_custom_service = {
    rest_service = {
      name            = "TestLinkedService"
      data_factory_id = module.data_factory.resource.id
      type            = "RestService"
      type_properties_json = jsonencode({
        authenticationType                = "Basic"
        url                               = "https://api.test.com"
        enableServerCertificateValidation = true
        userName                          = "testuser"
        password = {
          type       = "AzureKeyVaultSecret"
          secretName = "testpassword"
          store = {
            referenceName = "TestKeyVaultLinkedService"
            type          = "LinkedServiceReference"
          }
        }
      })

    }
  }
  tags = {
    environment = "test"
    function    = "datafactory"
  }

}
