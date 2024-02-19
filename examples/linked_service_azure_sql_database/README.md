<!-- BEGIN_TF_DOCS -->
# SQL Database example

Manages a Linked Service (connection) between Azure SQL Database and Azure Data Factory.

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
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.47.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# We need the tenant id.
data "azurerm_client_config" "this" {}

data "azuread_client_config" "this" {}

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

resource "azuread_group" "this" {
  display_name     = "Group-${module.naming.sql_server.name_unique}"
  owners           = [data.azuread_client_config.this.object_id]
  security_enabled = true
}

resource "azuread_group_member" "this" {
  group_object_id  = azuread_group.this.id
  member_object_id = module.data_factory.resource.identity[0].principal_id
}

module "sql_server" {
  source = "git::https://github.com/SkittleBomb/terraform-azurerm-avm-res-sql-server.git?ref=main"

  sqlserver_name      = module.naming.sql_server.name_unique
  resource_group_name = azurerm_resource_group.this.name
  azuread_administrator = {
    login_username              = azuread_group.this.display_name
    object_id                   = azuread_group.this.id
    azuread_authentication_only = true
  }

  private_endpoints = {
    private_endpoint1 = {
      location           = azurerm_resource_group.this.location
      subnet_resource_id = azurerm_subnet.this.id
    }
  }

  database = {
    db1 = {
      name         = module.naming.mssql_database.name_unique
      collation    = "SQL_Latin1_General_CP1_CI_AS"
      license_type = "LicenseIncluded"
      sku_name     = "S0"
    }
  }
}



# This is the module call
module "data_factory" {
  source = "../../"

  name                = module.naming.data_factory.name_unique
  resource_group_name = azurerm_resource_group.this.name

  public_network_enabled          = false
  managed_virtual_network_enabled = true

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


  linked_service_azure_sql_database = {
    db1 = {
      name                 = "linkedServiceAzureSqlDatabase1"
      connection_string    = "Data Source=tcp:${module.naming.sql_server.name_unique}.database.windows.net,1433;Initial Catalog=${module.naming.mssql_database.name_unique};Connection Timeout=30"
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

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (>=2.47.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.7.0, < 4.0.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0, < 4.0.0)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread) (>=2.47.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.7.0, < 4.0.0)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.5.0, < 4.0.0)

## Resources

The following resources are used by this module:

- [azuread_group.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) (resource)
- [azuread_group_member.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group_member) (resource)
- [azurerm_private_dns_zone.blob](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) (resource)
- [azurerm_private_dns_zone.datafactory](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) (resource)
- [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_subnet.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_virtual_network.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [random_integer.region_index](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/integer) (resource)
- [azuread_client_config.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/client_config) (data source)
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

### <a name="module_naming"></a> [naming](#module\_naming)

Source: Azure/naming/azurerm

Version: >= 0.3.0

### <a name="module_regions"></a> [regions](#module\_regions)

Source: Azure/regions/azurerm

Version: >= 0.3.0

### <a name="module_sql_server"></a> [sql\_server](#module\_sql\_server)

Source: git::https://github.com/SkittleBomb/terraform-azurerm-avm-res-sql-server.git

Version: main

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->