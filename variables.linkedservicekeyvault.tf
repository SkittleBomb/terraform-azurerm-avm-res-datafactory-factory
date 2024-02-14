variable "linked_service_key_vault" {
  type = map(object({
    name                     = string
    data_factory_id          = string
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
  default     = {}
  description = "Configuration for the Data Factory Linked Service Key Vault."
}
