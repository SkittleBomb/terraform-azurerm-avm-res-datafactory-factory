resource "azurerm_data_factory_linked_custom_service" "this" {
  for_each = var.linked_custom_service

  name                 = each.value.name
  data_factory_id      = azurerm_data_factory.this.id
  type                 = each.value.type
  type_properties_json = each.value.type_properties_json

  additional_properties = each.value.additional_properties

  annotations = each.value.annotations
  description = each.value.description

  dynamic "integration_runtime" {
    for_each = each.value.integration_runtime != null ? [each.value.integration_runtime] : []
    content {
      name       = integration_runtime.value.name
      parameters = integration_runtime.value.parameters
    }
  }

  parameters = each.value.parameters

  timeouts {
    create = try(each.value.timeouts.create, "30m")
    update = try(each.value.timeouts.update, "30m")
    read   = try(each.value.timeouts.read, "5m")
    delete = try(each.value.timeouts.delete, "30m")
  }
}
