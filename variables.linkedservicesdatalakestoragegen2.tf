variable "linked_service_data_lake_storage_gen2" {
  type = map(object({
    name                     = string
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
  description = <<DESC
Configuration for the Data Factory Linked Service Data Lake Storage Gen2.

The following arguments are supported:

- `name` - (Required) Specifies the name of the Data Factory Linked Service Data Lake Storage Gen2. Changing this forces a new resource to be created. Must be unique within a data factory.
- `description` - (Optional) The description for the Data Factory Linked Service Data Lake Storage Gen2.
- `integration_runtime_name` - (Optional) The integration runtime reference to associate with the Data Factory Linked Service Data Lake Storage Gen2.
- `annotations` - (Optional) List of tags that can be used for describing the Data Factory Linked Service Data Lake Storage Gen2.
- `parameters` - (Optional) A map of parameters to associate with the Data Factory Linked Service Data Lake Storage Gen2.
- `additional_properties` - (Optional) A map of additional properties to associate with the Data Factory Linked Service Data Lake Storage Gen2.
- `url` - (Required) The URL of the Data Lake Storage Gen2.
- `storage_account_key` - (Optional) The storage account key for the Data Lake Storage Gen2.
- `use_managed_identity` - (Optional) Whether to use the Data Factory's managed identity to authenticate against the Data Lake Storage Gen2.
- `service_principal_id` - (Optional) The service principal id in which to authenticate against the Data Lake Storage Gen2.
- `service_principal_key` - (Optional) The service principal key in which to authenticate against the Data Lake Storage Gen2.
- `tenant` - (Optional) The tenant id or name in which to authenticate against the Data Lake Storage Gen2.
- `timeouts` - (Optional) An optional timeouts block as defined below.

The `timeouts` block supports the following:

- `create` - (Optional) Used for Creating Timeouts. Default is 30 minutes.
- `update` - (Optional) Used for Updating Timeouts. Default is 30 minutes.
- `read` - (Optional) Used for Reading Timeouts. Default is 5 minutes.
- `delete` - (Optional) Used for Deleting Timeouts. Default is 30 minutes.
DESC
}

