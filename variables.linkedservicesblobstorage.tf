variable "linked_service_azure_blob_storage" {
  type = map(object({
    name                       = string
    data_factory_id            = string
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

  validation {
    condition     = length([for v in values(var.linked_service_azure_blob_storage) : 1 if v.connection_string != null || v.connection_string_insecure != null || v.sas_uri != null || v.service_endpoint != null]) == length(var.linked_service_azure_blob_storage)
    error_message = "At least one of `connection_string`, `connection_string_insecure`, `sas_uri`, or `service_endpoint` must be specified for each element in `linked_service_azure_blob_storage`."
  }

  default     = {}
  description = "Configuration for the Data Factory Linked Service Azure Blob Storage."
}
