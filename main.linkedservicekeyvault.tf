resource "azurerm_data_factory_linked_service_key_vault" "this" {
  for_each = var.linked_service_key_vault

  name                     = each.value.name
  data_factory_id          = azurerm_data_factory.this.id
  key_vault_id             = each.value.key_vault_id
  description              = each.value.description
  integration_runtime_name = each.value.integration_runtime_name
  annotations              = each.value.annotations
  parameters               = each.value.parameters
  additional_properties    = each.value.additional_properties

  timeouts {
    create = try(each.value.timeouts.create, "30m")
    update = try(each.value.timeouts.update, "30m")
    read   = try(each.value.timeouts.read, "5m")
    delete = try(each.value.timeouts.delete, "30m")
  }
}
