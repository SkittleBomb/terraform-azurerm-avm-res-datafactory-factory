variable "linked_custom_service" {
  type = map(object({
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

  default     = {}
  description = <<DESC
The configuration of the Data Factory Linked Service.

The following arguments are supported:

- `name` - (Required) Specifies the name of the Data Factory Linked Service. Changing this forces a new resource to be created. Must be unique within a data factory.
- `type` - (Required) The type of the Data Factory Linked Service.
- `type_properties_json` - (Required) The JSON string of the type properties for the Data Factory Linked Service.
- `additional_properties` - (Optional) A map of additional properties to associate with the Data Factory Linked Service.
- `annotations` - (Optional) List of tags that can be used for describing the Data Factory Linked Service.
- `description` - (Optional) The description for the Data Factory Linked Service.
- `integration_runtime` - (Optional) An integration_runtime block. Use this argument to specify the integration runtime for the Data Factory Linked Service.
- `parameters` - (Optional) A map of parameters to associate with the Data Factory Linked Service.
- `timeouts` - (Optional) An optional timeouts block as defined below.

The `timeouts` block supports the following:

- `create` - (Optional) Used for Creating Timeouts. Default is 30 minutes.
- `read` - (Optional) Used for Reading Timeouts. Default is 5 minutes.
- `update` - (Optional) Used for Updating Timeouts. Default is 30 minutes.
- `delete` - (Optional) Used for Deleting Timeouts. Default is 30 minutes.
DESC
}
