variable "linked_service_azure_databricks" {
  type = map(object({
    adb_domain      = string
    data_factory_id = string
    name            = string
    access_token    = optional(string)
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
  description = "Configuration for the Data Factory Linked Service Data Lake Storage Gen2."
}
