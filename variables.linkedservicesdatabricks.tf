variable "linked_service_azure_databricks" {
  type = map(object({
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

  validation {
    condition     = length([for v in values(var.linked_service_azure_databricks) : 1 if length(compact([v.access_token, v.key_vault_password != null ? "true" : null, v.msi_work_space_resource_id])) == 1]) == length(var.linked_service_azure_databricks)
    error_message = "Only one of `access_token`, `key_vault_password`, or `msi_work_space_resource_id` must be specified for each element in `linked_service_azure_databricks`."
  }

  default     = {}
  description = <<DESC
Configuration for the Data Factory Linked Service Azure Databricks.

The following arguments are supported:

- `adb_domain` - (Required) Specifies the Azure Databricks domain.
- `name` - (Required) Specifies the name of the Data Factory Linked Service Azure Databricks. Changing this forces a new resource to be created. Must be unique within a data factory.
- `access_token` - (Optional) The access token in which to authenticate with Azure Databricks.
- `key_vault_password` - (Optional) A key_vault_password block. Use this argument to store Azure Databricks password in an existing Key Vault. This block supports the following:
  - `linked_service_name` - (Required) Specifies the name of an existing Key Vault Data Factory Linked Service.
  - `secret_name` - (Required) Specifies the secret name in Azure Key Vault that stores Azure Databricks password.
- `msi_work_space_resource_id` - (Optional) The Managed Service Identity (MSI) workspace resource ID for Azure Databricks.
- `existing_cluster_id` - (Optional) The existing cluster ID for Azure Databricks.
- `instance_pool` - (Optional) An instance_pool block. Use this argument to specify the instance pool for Azure Databricks. This block supports the following:
  - `instance_pool_id` - (Required) Specifies the instance pool ID for Azure Databricks.
  - `cluster_version` - (Required) Specifies the cluster version for Azure Databricks.
  - `min_number_of_workers` - (Optional) Specifies the minimum number of workers for Azure Databricks.
  - `max_number_of_workers` - (Optional) Specifies the maximum number of workers for Azure Databricks.
- `new_cluster_config` - (Optional) A new_cluster_config block. Use this argument to specify the new cluster configuration for Azure Databricks. This block supports the following:
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
DESC
}