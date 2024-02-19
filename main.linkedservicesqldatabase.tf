resource "azurerm_data_factory_linked_service_azure_sql_database" "this" {
  for_each = var.linked_service_azure_sql_database

  name                     = each.value.name
  data_factory_id          = azurerm_data_factory.this.id
  connection_string        = each.value.connection_string
  use_managed_identity     = each.value.use_managed_identity
  service_principal_id     = each.value.service_principal_id
  service_principal_key    = each.value.service_principal_key
  tenant_id                = each.value.tenant_id
  description              = each.value.description
  integration_runtime_name = each.value.integration_runtime_name
  annotations              = each.value.annotations
  parameters               = each.value.parameters
  additional_properties    = each.value.additional_properties

  dynamic "key_vault_connection_string" {
    for_each = each.value.key_vault_connection_string != null ? [each.value.key_vault_connection_string] : []
    content {
      linked_service_name = key_vault_connection_string.value.linked_service_name
      secret_name         = key_vault_connection_string.value.secret_name
    }
  }

  dynamic "key_vault_password" {
    for_each = each.value.key_vault_password != null ? [each.value.key_vault_password] : []
    content {
      linked_service_name = key_vault_password.value.linked_service_name
      secret_name         = key_vault_password.value.secret_name
    }
  }

  timeouts {
    create = try(each.value.timeouts.create, "30m")
    update = try(each.value.timeouts.update, "30m")
    read   = try(each.value.timeouts.read, "5m")
    delete = try(each.value.timeouts.delete, "30m")
  }
}