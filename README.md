<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-res-datafactory-factory

Terraform module to deploy a Data Factory Factory in Azure.

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.6.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.71.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.71.0)

## Resources

The following resources are used by this module:

- [azurerm_data_factory.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory) (resource)
- [azurerm_data_factory_credential_user_managed_identity.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_credential_user_managed_identity) (resource)
- [azurerm_data_factory_linked_custom_service.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_custom_service) (resource)
- [azurerm_data_factory_linked_service_azure_blob_storage.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_azure_blob_storage) (resource)
- [azurerm_data_factory_linked_service_azure_databricks.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_azure_databricks) (resource)
- [azurerm_data_factory_linked_service_azure_sql_database.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_azure_sql_database) (resource)
- [azurerm_data_factory_linked_service_data_lake_storage_gen2.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_data_lake_storage_gen2) (resource)
- [azurerm_data_factory_linked_service_key_vault.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_linked_service_key_vault) (resource)
- [azurerm_data_factory_managed_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory_managed_private_endpoint) (resource)
- [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) (resource)
- [azurerm_monitor_diagnostic_setting.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) (resource)
- [azurerm_private_endpoint.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) (resource)
- [azurerm_private_endpoint_application_security_group_association.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint_application_security_group_association) (resource)
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [azurerm_resource_group.parent](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

The following input variables are required:

### <a name="input_name"></a> [name](#input\_name)

Description: The name of the data factory.

Type: `string`

### <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)

Description: The resource group where the resources will be deployed.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_customer_managed_key_id"></a> [customer\_managed\_key\_id](#input\_customer\_managed\_key\_id)

Description: Specifies the Azure Key Vault Key ID to be used as the Customer Managed Key (CMK) for double encryption.

Type: `string`

Default: `null`

### <a name="input_customer_managed_key_identity_id"></a> [customer\_managed\_key\_identity\_id](#input\_customer\_managed\_key\_identity\_id)

Description: Specifies the ID of the user assigned identity associated with the Customer Managed Key.

Type: `string`

Default: `null`

### <a name="input_data_factory_credentials"></a> [data\_factory\_credentials](#input\_data\_factory\_credentials)

Description: Configuration for the Data Factory Credentials and User Assigned Managed Identities.

Type:

```hcl
map(object({
    user_assigned_identity_name = optional(string, null)
    credential_description      = optional(string, null)
    user_assigned_identity_id   = optional(string, null)
    credential_annotations      = optional(list(string), null)
  }))
```

Default: `{}`

### <a name="input_diagnostic_settings"></a> [diagnostic\_settings](#input\_diagnostic\_settings)

Description: A map of diagnostic settings to create. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the diagnostic setting. One will be generated if not set, however this will not be unique if you want to create multiple diagnostic setting resources.
- `log_categories` - (Optional) A set of log categories to send to the log analytics workspace. Defaults to `[]`.
- `log_groups` - (Optional) A set of log groups to send to the log analytics workspace. Defaults to `["allLogs"]`.
- `metric_categories` - (Optional) A set of metric categories to send to the log analytics workspace. Defaults to `["AllMetrics"]`.
- `log_analytics_destination_type` - (Optional) The destination type for the diagnostic setting. Possible values are `Dedicated` and `AzureDiagnostics`. Defaults to `Dedicated`.
- `workspace_resource_id` - (Optional) The resource ID of the log analytics workspace to send logs and metrics to.
- `storage_account_resource_id` - (Optional) The resource ID of the storage account to send logs and metrics to.
- `event_hub_authorization_rule_resource_id` - (Optional) The resource ID of the event hub authorization rule to send logs and metrics to.
- `event_hub_name` - (Optional) The name of the event hub. If none is specified, the default event hub will be selected.
- `marketplace_partner_resource_id` - (Optional) The full ARM resource ID of the Marketplace resource to which you would like to send Diagnostic LogsLogs.

Type:

```hcl
map(object({
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
    marketplace_partner_resource_id          = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_github_configuration"></a> [github\_configuration](#input\_github\_configuration)

Description: A github\_configuration block.

Type:

```hcl
object({
    account_name       = string
    branch_name        = string
    git_url            = string
    repository_name    = string
    root_folder        = string
    publishing_enabled = optional(bool)
  })
```

Default: `null`

### <a name="input_global_parameter"></a> [global\_parameter](#input\_global\_parameter)

Description: A list of global\_parameter blocks.

Type:

```hcl
list(object({
    name  = string
    type  = string
    value = string
  }))
```

Default: `[]`

### <a name="input_identity"></a> [identity](#input\_identity)

Description: An identity block.

Type:

```hcl
object({
    type         = string
    identity_ids = list(string)
  })
```

Default:

```json
{
  "identity_ids": [],
  "type": "SystemAssigned"
}
```

### <a name="input_linked_custom_service"></a> [linked\_custom\_service](#input\_linked\_custom\_service)

Description: The configuration of the Data Factory Linked Service.

The following arguments are supported:

- `name` - (Required) Specifies the name of the Data Factory Linked Service. Changing this forces a new resource to be created. Must be unique within a data factory.
- `type` - (Required) The type of the Data Factory Linked Service.
- `type_properties_json` - (Required) The JSON string of the type properties for the Data Factory Linked Service.
- `additional_properties` - (Optional) A map of additional properties to associate with the Data Factory Linked Service.
- `annotations` - (Optional) List of tags that can be used for describing the Data Factory Linked Service.
- `description` - (Optional) The description for the Data Factory Linked Service.
- `integration_runtime` - (Optional) An integration\_runtime block. Use this argument to specify the integration runtime for the Data Factory Linked Service.
- `parameters` - (Optional) A map of parameters to associate with the Data Factory Linked Service.
- `timeouts` - (Optional) An optional timeouts block as defined below.

The `timeouts` block supports the following:

- `create` - (Optional) Used for Creating Timeouts. Default is 30 minutes.
- `read` - (Optional) Used for Reading Timeouts. Default is 5 minutes.
- `update` - (Optional) Used for Updating Timeouts. Default is 30 minutes.
- `delete` - (Optional) Used for Deleting Timeouts. Default is 30 minutes.

Type:

```hcl
map(object({
    name                  = string
    type                  = string
    type_properties_json  = string
    additional_properties = optional(map(string))
    annotations           = optional(list(string))
    description           = optional(string)
    integration_runtime = optional(object({
      name       = string
      parameters = optional(map(string))
    }))
    parameters = optional(map(string))
    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      update = optional(string)
      delete = optional(string)
    }))
  }))
```

Default: `{}`

### <a name="input_linked_service_azure_blob_storage"></a> [linked\_service\_azure\_blob\_storage](#input\_linked\_service\_azure\_blob\_storage)

Description: Configuration for the Data Factory Linked Service Azure Blob Storage.

The following arguments are supported:

- `name` - (Required) Specifies the name of the Data Factory Linked Service Azure Blob Storage. Changing this forces a new resource to be created. Must be unique within a data factory.
- `description` - (Optional) The description for the Data Factory Linked Service Azure Blob Storage.
- `integration_runtime_name` - (Optional) The integration runtime reference to associate with the Data Factory Linked Service Azure Blob Storage.
- `annotations` - (Optional) List of tags that can be used for describing the Data Factory Linked Service Azure Blob Storage.
- `parameters` - (Optional) A map of parameters to associate with the Data Factory Linked Service Azure Blob Storage.
- `additional_properties` - (Optional) A map of additional properties to associate with the Data Factory Linked Service Azure Blob Storage.
- `connection_string` - (Optional) The connection string in which to authenticate with Azure Blob Storage.
- `connection_string_insecure` - (Optional) The insecure connection string in which to authenticate with Azure Blob Storage.
- `sas_uri` - (Optional) The SAS URI in which to authenticate with Azure Blob Storage.
- `key_vault_sas_token` - (Optional) A key\_vault\_sas\_token block. Use this argument to store Azure Blob Storage SAS token in an existing Key Vault.
- `service_principal_linked_key_vault_key` - (Optional) A service\_principal\_linked\_key\_vault\_key block. Use this argument to store Azure Blob Storage service principal key in an existing Key Vault.
- `service_endpoint` - (Optional) The service endpoint for Azure Blob Storage.
- `use_managed_identity` - (Optional) Whether to use the Data Factory's managed identity to authenticate against the Azure Blob Storage.
- `service_principal_id` - (Optional) The service principal id in which to authenticate against the Azure Blob Storage.
- `service_principal_key` - (Optional) The service principal key in which to authenticate against the Azure Blob Storage.
- `storage_kind` - (Optional) The kind of storage for Azure Blob Storage.
- `tenant_id` - (Optional) The tenant id or name in which to authenticate against the Azure Blob Storage.
- `timeouts` - (Optional) An optional timeouts block as defined below.

The `timeouts` block supports the following:

- `create` - (Optional) Used for Creating Timeouts. Default is 30 minutes.
- `read` - (Optional) Used for Reading Timeouts. Default is 5 minutes.
- `update` - (Optional) Used for Updating Timeouts. Default is 30 minutes.
- `delete` - (Optional) Used for Deleting Timeouts. Default is 30 minutes.

Type:

```hcl
map(object({
    name                       = string
    description                = optional(string)
    integration_runtime_name   = optional(string)
    annotations                = optional(list(string))
    parameters                 = optional(map(string))
    additional_properties      = optional(map(string))
    connection_string          = optional(string)
    connection_string_insecure = optional(string)
    sas_uri                    = optional(string)
    key_vault_sas_token = optional(object({
      linked_service_name = string
      secret_name         = string
    }))
    service_principal_linked_key_vault_key = optional(object({
      linked_service_name = string
      secret_name         = string
    }))
    service_endpoint      = optional(string)
    use_managed_identity  = optional(bool)
    service_principal_id  = optional(string)
    service_principal_key = optional(string)
    storage_kind          = optional(string)
    tenant_id             = optional(string)
    timeouts = optional(object({
      create = optional(string)
      update = optional(string)
      read   = optional(string)
      delete = optional(string)
    }))
  }))
```

Default: `{}`

### <a name="input_linked_service_azure_databricks"></a> [linked\_service\_azure\_databricks](#input\_linked\_service\_azure\_databricks)

Description: Configuration for the Data Factory Linked Service Azure Databricks.

The following arguments are supported:

- `adb_domain` - (Required) Specifies the Azure Databricks domain.
- `name` - (Required) Specifies the name of the Data Factory Linked Service Azure Databricks. Changing this forces a new resource to be created. Must be unique within a data factory.
- `access_token` - (Optional) The access token in which to authenticate with Azure Databricks.
- `key_vault_password` - (Optional) A key\_vault\_password block. Use this argument to store Azure Databricks password in an existing Key Vault. This block supports the following:
  - `linked_service_name` - (Required) Specifies the name of an existing Key Vault Data Factory Linked Service.
  - `secret_name` - (Required) Specifies the secret name in Azure Key Vault that stores Azure Databricks password.
- `msi_work_space_resource_id` - (Optional) The Managed Service Identity (MSI) workspace resource ID for Azure Databricks.
- `existing_cluster_id` - (Optional) The existing cluster ID for Azure Databricks.
- `instance_pool` - (Optional) An instance\_pool block. Use this argument to specify the instance pool for Azure Databricks. This block supports the following:
  - `instance_pool_id` - (Required) Specifies the instance pool ID for Azure Databricks.
  - `cluster_version` - (Required) Specifies the cluster version for Azure Databricks.
  - `min_number_of_workers` - (Optional) Specifies the minimum number of workers for Azure Databricks.
  - `max_number_of_workers` - (Optional) Specifies the maximum number of workers for Azure Databricks.
- `new_cluster_config` - (Optional) A new\_cluster\_config block. Use this argument to specify the new cluster configuration for Azure Databricks. This block supports the following:
  - `cluster_version` - (Required) Specifies the cluster version for Azure Databricks.
  - `node_type` - (Required) Specifies the node type for Azure Databricks.
  - `custom_tags` - (Optional) Specifies the custom tags for Azure Databricks.
  - `driver_node_type` - (Optional) Specifies the driver node type for Azure Databricks.
  - `init_scripts` - (Optional) Specifies the initialization scripts for Azure Databricks.
  - `log_destination` - (Optional) Specifies the log destination for Azure Databricks.
  - `max_number_of_workers` - (Optional) Specifies the maximum number of workers for Azure Databricks.
  - `min_number_of_workers` - (Optional) Specifies the minimum number of workers for Azure Databricks.
  - `spark_config` - (Optional) Specifies the Spark configuration for Azure Databricks.
  - `spark_environment_variables` - (Optional) Specifies the Spark environment variables for Azure Databricks.
- `additional_properties` - (Optional) A map of additional properties to associate with the Data Factory Linked Service Azure Databricks.
- `annotations` - (Optional) List of tags that can be used for describing the Data Factory Linked Service Azure Databricks.
- `description` - (Optional) The description for the Data Factory Linked Service Azure Databricks.
- `integration_runtime_name` - (Optional) The integration runtime reference to associate with the Data Factory Linked Service Azure Databricks.
- `parameters` - (Optional) A map of parameters to associate with the Data Factory Linked Service Azure Databricks.
- `timeouts` - (Optional) An optional timeouts block as defined below.

The `timeouts` block supports the following:

- `create` - (Optional) Used for Creating Timeouts. Default is 30 minutes.
- `read` - (Optional) Used for Reading Timeouts. Default is 5 minutes.
- `update` - (Optional) Used for Updating Timeouts. Default is 30 minutes.
- `delete` - (Optional) Used for Deleting Timeouts. Default is 30 minutes.

Type:

```hcl
map(object({
    adb_domain   = string
    name         = string
    access_token = optional(string)
    key_vault_password = optional(object({
      linked_service_name = string
      secret_name         = string
    }))
    msi_work_space_resource_id = optional(string)
    existing_cluster_id        = optional(string)
    instance_pool = optional(object({
      instance_pool_id      = string
      cluster_version       = string
      min_number_of_workers = optional(number)
      max_number_of_workers = optional(number)
    }))
    new_cluster_config = optional(object({
      cluster_version             = string
      node_type                   = string
      custom_tags                 = optional(map(string))
      driver_node_type            = optional(string)
      init_scripts                = optional(list(string))
      log_destination             = optional(string)
      max_number_of_workers       = optional(number)
      min_number_of_workers       = optional(number)
      spark_config                = optional(map(string))
      spark_environment_variables = optional(map(string))
    }))
    additional_properties    = optional(map(string))
    annotations              = optional(list(string))
    description              = optional(string)
    integration_runtime_name = optional(string)
    parameters               = optional(map(string))
    timeouts = optional(object({
      create = optional(string)
      update = optional(string)
      read   = optional(string)
      delete = optional(string)
    }))
  }))
```

Default: `{}`

### <a name="input_linked_service_azure_sql_database"></a> [linked\_service\_azure\_sql\_database](#input\_linked\_service\_azure\_sql\_database)

Description: Configuration options for the Azure SQL Database linked service.

The following arguments are supported:

- `name` - (Required) Specifies the name of the Data Factory Linked Service Azure SQL Database. Changing this forces a new resource to be created. Must be unique within a data factory.
- `connection_string` - (Optional) The connection string in which to authenticate with Azure SQL Database. Exactly one of either connection\_string or key\_vault\_connection\_string is required.
- `use_managed_identity` - (Optional) Whether to use the Data Factory's managed identity to authenticate against the Azure SQL Database. Incompatible with service\_principal\_id and service\_principal\_key
- `service_principal_id` - (Optional) The service principal id in which to authenticate against the Azure SQL Database. Required if service\_principal\_key is set.
- `service_principal_key` - (Optional) The service principal key in which to authenticate against the Azure SQL Database. Required if service\_principal\_id is set.
- `tenant_id` - (Optional) The tenant id or name in which to authenticate against the Azure SQL Database.
- `description` - (Optional) The description for the Data Factory Linked Service Azure SQL Database.
- `integration_runtime_name` - (Optional) The integration runtime reference to associate with the Data Factory Linked Service Azure SQL Database.
- `annotations` - (Optional) List of tags that can be used for describing the Data Factory Linked Service Azure SQL Database.
- `parameters` - (Optional) A map of parameters to associate with the Data Factory Linked Service Azure SQL Database.
- `additional_properties` - (Optional) A map of additional properties to associate with the Data Factory Linked Service Azure SQL Database.
- `key_vault_connection_string` - (Optional) A key\_vault\_connection\_string block. Use this argument to store Azure SQL Database connection string in an existing Key Vault. It needs an existing Key Vault Data Factory Linked Service. Exactly one of either connection\_string or key\_vault\_connection\_string is required.
- `key_vault_password` - (Optional) A key\_vault\_password block. Use this argument to store SQL Server password in an existing Key Vault. It needs an existing Key Vault Data Factory Linked Service.

A `key_vault_connection_string` block supports the following:

- `linked_service_name` - (Required) Specifies the name of an existing Key Vault Data Factory Linked Service.
- `secret_name` - (Required) Specifies the secret name in Azure Key Vault that stores SQL Server connection string.

A `key_vault_password` block supports the following:

- `linked_service_name` - (Required) Specifies the name of an existing Key Vault Data Factory Linked Service.
- `secret_name` - (Required) Specifies the secret name in Azure Key Vault that stores SQL Server password.

Type:

```hcl
map(object({
    name                     = string
    connection_string        = optional(string)
    use_managed_identity     = optional(bool)
    service_principal_id     = optional(string)
    service_principal_key    = optional(string)
    tenant_id                = optional(string)
    description              = optional(string)
    integration_runtime_name = optional(string)
    annotations              = optional(list(string))
    parameters               = optional(map(string))
    additional_properties    = optional(map(string))
    key_vault_connection_string = optional(object({
      linked_service_name = string
      secret_name         = string
    }))
    key_vault_password = optional(object({
      linked_service_name = string
      secret_name         = string
    }))
    timeouts = optional(object({
      create = optional(string)
      update = optional(string)
      read   = optional(string)
      delete = optional(string)
    }))
  }))
```

Default: `{}`

### <a name="input_linked_service_data_lake_storage_gen2"></a> [linked\_service\_data\_lake\_storage\_gen2](#input\_linked\_service\_data\_lake\_storage\_gen2)

Description: Configuration for the Data Factory Linked Service Data Lake Storage Gen2.

The following arguments are supported:

- `name` - (Required) Specifies the name of the Data Factory Linked Service Data Lake Storage Gen2. Changing this forces a new resource to be created. Must be unique within a data factory.
- `description` - (Optional) The description for the Data Factory Linked Service Data Lake Storage Gen2.
- `integration_runtime_name` - (Optional) The integration runtime reference to associate with the Data Factory Linked Service Data Lake Storage Gen2.
- `annotations` - (Optional) List of tags that can be used for describing the Data Factory Linked Service Data Lake Storage Gen2.
- `parameters` - (Optional) A map of parameters to associate with the Data Factory Linked Service Data Lake Storage Gen2.
- `additional_properties` - (Optional) A map of additional properties to associate with the Data Factory Linked Service Data Lake Storage Gen2.
- `url` - (Required) The URL of the Data Lake Storage Gen2.
- `storage_account_key` - (Optional) The storage account key for the Data Lake Storage Gen2.
- `use_managed_identity` - (Optional) Whether to use the Data Factory's managed identity to authenticate against the Data Lake Storage Gen2.
- `service_principal_id` - (Optional) The service principal id in which to authenticate against the Data Lake Storage Gen2.
- `service_principal_key` - (Optional) The service principal key in which to authenticate against the Data Lake Storage Gen2.
- `tenant` - (Optional) The tenant id or name in which to authenticate against the Data Lake Storage Gen2.
- `timeouts` - (Optional) An optional timeouts block as defined below.

The `timeouts` block supports the following:

- `create` - (Optional) Used for Creating Timeouts. Default is 30 minutes.
- `update` - (Optional) Used for Updating Timeouts. Default is 30 minutes.
- `read` - (Optional) Used for Reading Timeouts. Default is 5 minutes.
- `delete` - (Optional) Used for Deleting Timeouts. Default is 30 minutes.

Type:

```hcl
map(object({
    name                     = string
    description              = optional(string)
    integration_runtime_name = optional(string)
    annotations              = optional(list(string))
    parameters               = optional(map(string))
    additional_properties    = optional(map(string))
    url                      = string
    storage_account_key      = optional(string)
    use_managed_identity     = optional(bool)
    service_principal_id     = optional(string)
    service_principal_key    = optional(string)
    tenant                   = optional(string)
    timeouts = optional(object({
      create = optional(string)
      update = optional(string)
      read   = optional(string)
      delete = optional(string)
    }))
  }))
```

Default: `{}`

### <a name="input_linked_service_key_vault"></a> [linked\_service\_key\_vault](#input\_linked\_service\_key\_vault)

Description: Configuration for the Data Factory Linked Service Key Vault.

The following arguments are supported:

- `name` - (Required) Specifies the name of the Data Factory Linked Service Key Vault. Changing this forces a new resource to be created. Must be unique within a data factory.
- `key_vault_id` - (Required) The Key Vault ID in which to associate the Linked Service with. Changing this forces a new resource.
- `description` - (Optional) The description for the Data Factory Linked Service Key Vault.
- `integration_runtime_name` - (Optional) The integration runtime reference to associate with the Data Factory Linked Service Key Vault.
- `annotations` - (Optional) List of tags that can be used for describing the Data Factory Linked Service Key Vault.
- `parameters` - (Optional) A map of parameters to associate with the Data Factory Linked Service Key Vault.
- `additional_properties` - (Optional) A map of additional properties to associate with the Data Factory Linked Service Key Vault.
- `timeouts` - (Optional) An optional timeouts block as defined below.

The `timeouts` block supports the following:

- `create` - (Optional) Used for Creating Timeouts. Default is 30 minutes.
- `update` - (Optional) Used for Updating Timeouts. Default is 30 minutes.
- `read` - (Optional) Used for Reading Timeouts. Default is 5 minutes.
- `delete` - (Optional) Used for Deleting Timeouts. Default is 30 minutes.

Type:

```hcl
map(object({
    name                     = string
    key_vault_id             = string
    description              = optional(string)
    integration_runtime_name = optional(string)
    annotations              = optional(list(string))
    parameters               = optional(map(string))
    additional_properties    = optional(map(string))
    timeouts = optional(object({
      create = optional(string)
      update = optional(string)
      read   = optional(string)
      delete = optional(string)
    }))
  }))
```

Default: `{}`

### <a name="input_location"></a> [location](#input\_location)

Description: Azure region where the resource should be deployed.  If null, the location will be inferred from the resource group location.

Type: `string`

Default: `null`

### <a name="input_lock"></a> [lock](#input\_lock)

Description: The lock level to apply. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.

Type:

```hcl
object({
    name = optional(string, null)
    kind = optional(string, "None")
  })
```

Default: `{}`

### <a name="input_managed_private_endpoint"></a> [managed\_private\_endpoint](#input\_managed\_private\_endpoint)

Description: Configuration for the Managed Private Endpoint.

The following arguments are supported:

- `name` - (Required) Specifies the name which should be used for this Managed Private Endpoint. Changing this forces a new resource to be created.
- `target_resource_id` - (Required) The ID of the Private Link Enabled Remote Resource which this Data Factory Private Endpoint should be connected to. Changing this forces a new resource to be created.
- `subresource_name` - (Optional) Specifies the sub resource name which the Data Factory Private Endpoint is able to connect to. Changing this forces a new resource to be created.
- `fqdns` - (Optional) Fully qualified domain names. Changing this forces a new resource to be created.
- `timeouts` - (Optional) An optional timeouts block as defined below.

The `timeouts` block supports the following:

- `create` - (Optional) Used for Creating Timeouts. Default is 30 minutes.
- `read` - (Optional) Used for Reading Timeouts. Default is 5 minutes.
- `delete` - (Optional) Used for Deleting Timeouts. Default is 30 minutes.

Type:

```hcl
map(object({
    name               = string
    target_resource_id = string
    subresource_name   = optional(string)
    fqdns              = optional(list(string))
    timeouts = optional(object({
      create = optional(string)
      read   = optional(string)
      delete = optional(string)
    }))
  }))
```

Default: `{}`

### <a name="input_managed_virtual_network_enabled"></a> [managed\_virtual\_network\_enabled](#input\_managed\_virtual\_network\_enabled)

Description: Is Managed Virtual Network enabled?

Type: `bool`

Default: `false`

### <a name="input_private_endpoints"></a> [private\_endpoints](#input\_private\_endpoints)

Description: A map of private endpoints to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `name` - (Optional) The name of the private endpoint. One will be generated if not set.#- `subresource_name` - The subresource name for the private endpoint. Must be one of "datafactory" or "portal".
- `role_assignments` - (Optional) A map of role assignments to create on the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time. See `var.role_assignments` for more information.
- `lock` - (Optional) The lock level to apply to the private endpoint. Default is `None`. Possible values are `None`, `CanNotDelete`, and `ReadOnly`.
- `tags` - (Optional) A mapping of tags to assign to the private endpoint.
- `subnet_resource_id` - The resource ID of the subnet to deploy the private endpoint in.
- `private_dns_zone_group_name` - (Optional) The name of the private DNS zone group. One will be generated if not set.
- `private_dns_zone_resource_ids` - (Optional) A set of resource IDs of private DNS zones to associate with the private endpoint. If not set, no zone groups will be created and the private endpoint will not be associated with any private DNS zones. DNS records must be managed external to this module.
- `application_security_group_resource_ids` - (Optional) A map of resource IDs of application security groups to associate with the private endpoint. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
- `private_service_connection_name` - (Optional) The name of the private service connection. One will be generated if not set.
- `network_interface_name` - (Optional) The name of the network interface. One will be generated if not set.
- `location` - (Optional) The Azure location where the resources will be deployed. Defaults to the location of the resource group.
- `resource_group_name` - (Optional) The resource group where the resources will be deployed. Defaults to the resource group of this resource.
- `ip_configurations` - (Optional) A map of IP configurations to create on the private endpoint. If not specified the platform will create one. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.
  - `name` - The name of the IP configuration.
  - `private_ip_address` - The private IP address of the IP configuration.

Type:

```hcl
map(object({
    name             = optional(string, null)
    subresource_name = string
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
    })), {})
    lock = optional(object({
      name = optional(string, null)
      kind = optional(string, "None")
    }), {})
    tags                                    = optional(map(any), null)
    subnet_resource_id                      = string
    private_dns_zone_group_name             = optional(string, "default")
    private_dns_zone_resource_ids           = optional(set(string), [])
    application_security_group_associations = optional(map(string), {})
    private_service_connection_name         = optional(string, null)
    network_interface_name                  = optional(string, null)
    location                                = optional(string, null)
    resource_group_name                     = optional(string, null)
    ip_configurations = optional(map(object({
      name               = string
      private_ip_address = string
    })), {})
  }))
```

Default: `{}`

### <a name="input_public_network_enabled"></a> [public\_network\_enabled](#input\_public\_network\_enabled)

Description: Is the Data Factory visible to the public network?

Type: `bool`

Default: `false`

### <a name="input_purview_id"></a> [purview\_id](#input\_purview\_id)

Description: Specifies the ID of the purview account resource associated with the Data Factory.

Type: `string`

Default: `null`

### <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments)

Description: A map of role assignments to create on this resource. The map key is deliberately arbitrary to avoid issues where map keys maybe unknown at plan time.

- `role_definition_id_or_name` - The ID or name of the role definition to assign to the principal.
- `principal_id` - The ID of the principal to assign the role to.
- `description` - The description of the role assignment.
- `skip_service_principal_aad_check` - If set to true, skips the Azure Active Directory check for the service principal in the tenant. Defaults to false.
- `condition` - The condition which will be used to scope the role assignment.
- `condition_version` - The version of the condition syntax. Valid values are '2.0'.

> Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.

Type:

```hcl
map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
```

Default: `{}`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: The map of tags to be applied to the resource

Type: `map(any)`

Default: `{}`

### <a name="input_vsts_configuration"></a> [vsts\_configuration](#input\_vsts\_configuration)

Description: A vsts\_configuration block.

Type:

```hcl
object({
    account_name       = string
    branch_name        = string
    project_name       = string
    repository_name    = string
    root_folder        = string
    tenant_id          = string
    publishing_enabled = optional(bool)
  })
```

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_data_factory_credential_user_managed_identity_id"></a> [data\_factory\_credential\_user\_managed\_identity\_id](#output\_data\_factory\_credential\_user\_managed\_identity\_id)

Description: The ID of the Data Factory User Managed Identity Credential.

### <a name="output_linked_custom_service"></a> [linked\_custom\_service](#output\_linked\_custom\_service)

Description: A map of Data Factory Linked Custom Service resources.

### <a name="output_linked_service_azure_blob_storage"></a> [linked\_service\_azure\_blob\_storage](#output\_linked\_service\_azure\_blob\_storage)

Description: A map of Data Factory Linked Service Azure Blob Storage resources.

### <a name="output_linked_service_azure_databricks"></a> [linked\_service\_azure\_databricks](#output\_linked\_service\_azure\_databricks)

Description: A map of Data Factory Linked Service Azure Databricks resources.

### <a name="output_linked_service_azure_sql_database_ids"></a> [linked\_service\_azure\_sql\_database\_ids](#output\_linked\_service\_azure\_sql\_database\_ids)

Description: The IDs of the Data Factory Linked Service Azure SQL Database.

### <a name="output_linked_service_data_lake_storage_gen2"></a> [linked\_service\_data\_lake\_storage\_gen2](#output\_linked\_service\_data\_lake\_storage\_gen2)

Description: A map of Data Factory Linked Service Data Lake Storage Gen2 resources. The map key is the supplied input to var.linked\_service\_data\_lake\_storage\_gen2. The map value is the entire azurerm\_data\_factory\_linked\_service\_data\_lake\_storage\_gen2 resource.

### <a name="output_linked_service_key_vault"></a> [linked\_service\_key\_vault](#output\_linked\_service\_key\_vault)

Description: A map of Data Factory Linked Service Key Vault resources.

### <a name="output_private_endpoints"></a> [private\_endpoints](#output\_private\_endpoints)

Description: A map of private endpoints. The map key is the supplied input to var.private\_endpoints. The map value is the entire azurerm\_private\_endpoint resource.

### <a name="output_resource"></a> [resource](#output\_resource)

Description: This is the full output for the resource.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->