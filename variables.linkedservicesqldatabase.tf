variable "linked_service_azure_sql_database" {
  type = map(object({
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

  validation {
    condition     = length([for ls in var.linked_service_azure_sql_database : ls if ls.connection_string != null || ls.key_vault_connection_string != null]) == length(var.linked_service_azure_sql_database)
    error_message = "Each linked service must have either a connection_string or a key_vault_connection_string."
  }

  default     = {}
  description = "Configuration options for the Azure SQL Database linked service."
}
