variable "linked_service_key_vault" {
  type = map(object({
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
  default     = {}
  description = <<DESC
Configuration for the Data Factory Linked Service Key Vault.

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
DESC
}
