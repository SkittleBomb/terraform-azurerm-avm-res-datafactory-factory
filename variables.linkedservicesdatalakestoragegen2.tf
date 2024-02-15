variable "linked_service_data_lake_storage_gen2" {
  type = map(object({
    name                     = string
    data_factory_id          = string
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

  validation {
    condition     = length([for v in values(var.linked_service_data_lake_storage_gen2) : 1 if length(compact([v.storage_account_key, tostring(v.use_managed_identity), v.service_principal_id])) == 1]) == length(var.linked_service_data_lake_storage_gen2)
    error_message = "Only one of `storage_account_key`, `use_managed_identity`, or `service_principal_id` must be specified for each element in `linked_service_data_lake_storage_gen2`."
  }

  default     = {}
  description = "Configuration for the Data Factory Linked Service Data Lake Storage Gen2."
}

