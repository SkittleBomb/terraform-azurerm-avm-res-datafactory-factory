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
  description = <<DESC
Configuration options for the Azure SQL Database linked service.

The following arguments are supported:

- `name` - (Required) Specifies the name of the Data Factory Linked Service Azure SQL Database. Changing this forces a new resource to be created. Must be unique within a data factory.
- `connection_string` - (Optional) The connection string in which to authenticate with Azure SQL Database. Exactly one of either connection_string or key_vault_connection_string is required.
- `use_managed_identity` - (Optional) Whether to use the Data Factory's managed identity to authenticate against the Azure SQL Database. Incompatible with service_principal_id and service_principal_key
- `service_principal_id` - (Optional) The service principal id in which to authenticate against the Azure SQL Database. Required if service_principal_key is set.
- `service_principal_key` - (Optional) The service principal key in which to authenticate against the Azure SQL Database. Required if service_principal_id is set.
- `tenant_id` - (Optional) The tenant id or name in which to authenticate against the Azure SQL Database.
- `description` - (Optional) The description for the Data Factory Linked Service Azure SQL Database.
- `integration_runtime_name` - (Optional) The integration runtime reference to associate with the Data Factory Linked Service Azure SQL Database.
- `annotations` - (Optional) List of tags that can be used for describing the Data Factory Linked Service Azure SQL Database.
- `parameters` - (Optional) A map of parameters to associate with the Data Factory Linked Service Azure SQL Database.
- `additional_properties` - (Optional) A map of additional properties to associate with the Data Factory Linked Service Azure SQL Database.
- `key_vault_connection_string` - (Optional) A key_vault_connection_string block. Use this argument to store Azure SQL Database connection string in an existing Key Vault. It needs an existing Key Vault Data Factory Linked Service. Exactly one of either connection_string or key_vault_connection_string is required.
- `key_vault_password` - (Optional) A key_vault_password block. Use this argument to store SQL Server password in an existing Key Vault. It needs an existing Key Vault Data Factory Linked Service.

A `key_vault_connection_string` block supports the following:

- `linked_service_name` - (Required) Specifies the name of an existing Key Vault Data Factory Linked Service.
- `secret_name` - (Required) Specifies the secret name in Azure Key Vault that stores SQL Server connection string.

A `key_vault_password` block supports the following:

- `linked_service_name` - (Required) Specifies the name of an existing Key Vault Data Factory Linked Service.
- `secret_name` - (Required) Specifies the secret name in Azure Key Vault that stores SQL Server password.
DESC
}

