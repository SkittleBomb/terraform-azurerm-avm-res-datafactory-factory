variable "linked_service_azure_blob_storage" {
  type = map(object({
    name                       = string
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
  description = <<DESC
Configuration for the Data Factory Linked Service Azure Blob Storage.

The following arguments are supported:

- `name` - (Required) Specifies the name of the Data Factory Linked Service Azure Blob Storage. Changing this forces a new resource to be created. Must be unique within a data factory.
- `description` - (Optional) The description for the Data Factory Linked Service Azure Blob Storage.
- `integration_runtime_name` - (Optional) The integration runtime reference to associate with the Data Factory Linked Service Azure Blob Storage.
- `annotations` - (Optional) List of tags that can be used for describing the Data Factory Linked Service Azure Blob Storage.
- `parameters` - (Optional) A map of parameters to associate with the Data Factory Linked Service Azure Blob Storage.
- `additional_properties` - (Optional) A map of additional properties to associate with the Data Factory Linked Service Azure Blob Storage.
- `connection_string` - (Optional) The connection string in which to authenticate with Azure Blob Storage.
- `connection_string_insecure` - (Optional) The insecure connection string in which to authenticate with Azure Blob Storage.
- `sas_uri` - (Optional) The SAS URI in which to authenticate with Azure Blob Storage.
- `key_vault_sas_token` - (Optional) A key_vault_sas_token block. Use this argument to store Azure Blob Storage SAS token in an existing Key Vault.
- `service_principal_linked_key_vault_key` - (Optional) A service_principal_linked_key_vault_key block. Use this argument to store Azure Blob Storage service principal key in an existing Key Vault.
- `service_endpoint` - (Optional) The service endpoint for Azure Blob Storage.
- `use_managed_identity` - (Optional) Whether to use the Data Factory's managed identity to authenticate against the Azure Blob Storage.
- `service_principal_id` - (Optional) The service principal id in which to authenticate against the Azure Blob Storage.
- `service_principal_key` - (Optional) The service principal key in which to authenticate against the Azure Blob Storage.
- `storage_kind` - (Optional) The kind of storage for Azure Blob Storage.
- `tenant_id` - (Optional) The tenant id or name in which to authenticate against the Azure Blob Storage.
- `timeouts` - (Optional) An optional timeouts block as defined below.

The `timeouts` block supports the following:

- `create` - (Optional) Used for Creating Timeouts. Default is 30 minutes.
- `read` - (Optional) Used for Reading Timeouts. Default is 5 minutes.
- `update` - (Optional) Used for Updating Timeouts. Default is 30 minutes.
- `delete` - (Optional) Used for Deleting Timeouts. Default is 30 minutes.
DESC
}
