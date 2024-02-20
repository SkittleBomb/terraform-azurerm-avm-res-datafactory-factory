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

# A host (public) subnet is required for vnet injection.
resource "azurerm_subnet" "public" {
  address_prefixes     = ["10.0.1.0/24"]
  name                 = "${module.naming.subnet.name_unique}-public"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name

  delegation {
    name = "databricks-del-public"

    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
    }
  }
}

# A container (private) subnet is required for vnet injection.
resource "azurerm_subnet" "private" {
  address_prefixes     = ["10.0.2.0/24"]
  name                 = "${module.naming.subnet.name_unique}-private"
  resource_group_name  = azurerm_resource_group.this.name
  virtual_network_name = azurerm_virtual_network.this.name

  delegation {
    name = "databricks-del-private"

    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
    }
  }
}

# A private endpoint vnet
resource "azurerm_subnet" "privateendpoint" {
  address_prefixes                          = ["10.0.3.0/24"]
  name                                      = "${module.naming.subnet.name_unique}-private-endpoint"
  resource_group_name                       = azurerm_resource_group.this.name
  virtual_network_name                      = azurerm_virtual_network.this.name
  private_endpoint_network_policies_enabled = false
}

# A network security group association is required for vnet injection.
resource "azurerm_subnet_network_security_group_association" "private" {
  network_security_group_id = azurerm_network_security_group.this.id
  subnet_id                 = azurerm_subnet.private.id
}
resource "azurerm_subnet_network_security_group_association" "public" {
  network_security_group_id = azurerm_network_security_group.this.id
  subnet_id                 = azurerm_subnet.public.id
}
# A network security group is required for vnet injection.
resource "azurerm_network_security_group" "this" {
  location            = azurerm_resource_group.this.location
  name                = "databricks-nsg"
  resource_group_name = azurerm_resource_group.this.name

  security_rule {
    access                     = "Allow"
    description                = "Required for worker nodes communication within a cluster."
    destination_address_prefix = "VirtualNetwork"
    destination_port_range     = "*"
    direction                  = "Inbound"
    name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-inbound"
    priority                   = 100
    protocol                   = "*"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
  }
  security_rule {
    access                     = "Allow"
    description                = "Required for workers communication with Databricks Webapp."
    destination_address_prefix = "AzureDatabricks"
    destination_port_range     = "443"
    direction                  = "Outbound"
    name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-databricks-webapp"
    priority                   = 100
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
  }
  security_rule {
    access                     = "Allow"
    description                = "Required for workers communication with Azure SQL services."
    destination_address_prefix = "Sql"
    destination_port_range     = "3306"
    direction                  = "Outbound"
    name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-sql"
    priority                   = 101
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
  }
  security_rule {
    access                     = "Allow"
    description                = "Required for workers communication with Azure Storage services."
    destination_address_prefix = "Storage"
    destination_port_range     = "443"
    direction                  = "Outbound"
    name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-storage"
    priority                   = 102
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
  }
  security_rule {
    access                     = "Allow"
    description                = "Required for worker nodes communication within a cluster."
    destination_address_prefix = "VirtualNetwork"
    destination_port_range     = "*"
    direction                  = "Outbound"
    name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-worker-outbound"
    priority                   = 103
    protocol                   = "*"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
  }
  security_rule {
    access                     = "Allow"
    description                = "Required for worker communication with Azure Eventhub services."
    destination_address_prefix = "EventHub"
    destination_port_range     = "9093"
    direction                  = "Outbound"
    name                       = "Microsoft.Databricks-workspaces_UseOnly_databricks-worker-to-eventhub"
    priority                   = 104
    protocol                   = "Tcp"
    source_address_prefix      = "VirtualNetwork"
    source_port_range          = "*"
  }
}

# A private DNS zone for the private endpoint.
resource "azurerm_private_dns_zone" "azuredatabricks" {
  name                = "privatelink.azuredatabricks.net"
  resource_group_name = azurerm_resource_group.this.name
}




module "databricks" {
  source = "git::https://github.com/Azure/terraform-azurerm-avm-res-databricks-workspace.git?ref=main"

  name                = module.naming.databricks_workspace.name_unique
  resource_group_name = azurerm_resource_group.this.name
  enable_telemetry    = false

  sku                           = "premium"
  public_network_access_enabled = true
  custom_parameters = {
    no_public_ip                                         = true
    public_subnet_name                                   = azurerm_subnet.public.name
    public_subnet_network_security_group_association_id  = azurerm_subnet_network_security_group_association.public.id
    private_subnet_name                                  = azurerm_subnet.private.name
    private_subnet_network_security_group_association_id = azurerm_subnet_network_security_group_association.private.id
    virtual_network_id                                   = azurerm_virtual_network.this.id
  }

  private_endpoints = {
    databricks_ui_api = {
      subresource_name              = "databricks_ui_api"
      location                      = azurerm_resource_group.this.location
      private_dns_zone_resource_ids = [azurerm_private_dns_zone.azuredatabricks.id]
      subnet_resource_id            = azurerm_subnet.privateendpoint.id
    }
  }
  role_assignments = {
    contributor = {
      principal_id               = module.data_factory.resource.identity[0].principal_id
      role_definition_id_or_name = "Contributor"
    }
  }
}

resource "azurerm_private_dns_zone" "datafactory" {
  name                = "privatelink.datafactory.azure.net"
  resource_group_name = azurerm_resource_group.this.name
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
      subnet_resource_id            = azurerm_subnet.privateendpoint.id
      location                      = azurerm_resource_group.this.location
    },
    portal = {
      subresource_name              = "portal"
      private_dns_zone_resource_ids = [azurerm_private_dns_zone.datafactory.id]
      subnet_resource_id            = azurerm_subnet.privateendpoint.id
      location                      = azurerm_resource_group.this.location
    },
  }

  identity = {
    type         = "SystemAssigned"
    identity_ids = []
  }

  linked_service_azure_databricks = {
    data_bricks_1 = {
      name                       = "TestDatabricksLinkedService"
      adb_domain                 = format("https://%s", module.databricks.resource.workspace_url)
      msi_work_space_resource_id = module.databricks.resource.id
      new_cluster_config = {
        node_type       = "Standard_DS3_v2"
        cluster_version = "10.4.x-scala2.12"
      }
    }
  }
  tags = {
    environment = "test"
    function    = "datafactory"
  }
}
