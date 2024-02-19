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
