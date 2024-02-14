resource "azurerm_data_factory_linked_service_azure_blob_storage" "this" {
  for_each = var.linked_service_azure_blob_storage

  name                       = each.value.name
  data_factory_id            = azurerm_data_factory.this.id
  description                = each.value.description
  annotations                = each.value.annotations
  parameters                 = each.value.parameters
  additional_properties      = each.value.additional_properties
  connection_string          = each.value.connection_string
  connection_string_insecure = each.value.connection_string_insecure
  sas_uri                    = each.value.sas_uri

  dynamic "key_vault_sas_token" {
    for_each = each.value.key_vault_sas_token != null ? [1] : []
    content {
      linked_service_name = each.value.key_vault_sas_token.linked_service_name
      secret_name         = each.value.key_vault_sas_token.secret_name
    }
  }

  dynamic "service_principal_linked_key_vault_key" {
    for_each = each.value.service_principal_linked_key_vault_key != null ? [1] : []
    content {
      linked_service_name = each.value.service_principal_linked_key_vault_key.linked_service_name
      secret_name         = each.value.service_principal_linked_key_vault_key.secret_name
    }
  }

  service_endpoint      = each.value.service_endpoint
  use_managed_identity  = each.value.use_managed_identity
  service_principal_id  = each.value.service_principal_id
  service_principal_key = each.value.service_principal_key
  storage_kind          = each.value.storage_kind
  tenant_id             = each.value.tenant_id

  timeouts {
    create = try(each.value.timeouts.create, "30m")
    update = try(each.value.timeouts.update, "30m")
    read   = try(each.value.timeouts.read, "5m")
    delete = try(each.value.timeouts.delete, "30m")
  }
}
