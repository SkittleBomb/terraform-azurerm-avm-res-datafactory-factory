variable "linked_custom_service" {
  type = map(object({
    name                  = string
    data_factory_id       = string
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

  default     = {}
  description = "The configuration of the Data Factory Linked Service"
}
