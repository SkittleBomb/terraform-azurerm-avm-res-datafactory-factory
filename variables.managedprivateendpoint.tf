variable "managed_private_endpoint" {
  type = map(object({
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
  default     = {}
  description = <<DESC
Configuration for the Managed Private Endpoint.

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
DESC
}