resource "azurerm_data_factory_linked_service_data_lake_storage_gen2" "this" {
  for_each = var.linked_service_data_lake_storage_gen2

  name                     = each.value.name
  data_factory_id          = azurerm_data_factory.this.id
  url                      = each.value.url
  description              = each.value.description
  integration_runtime_name = each.value.integration_runtime_name
  annotations              = each.value.annotations
  parameters               = each.value.parameters
  additional_properties    = each.value.additional_properties

  storage_account_key  = each.value.storage_account_key
  use_managed_identity = each.value.use_managed_identity

  service_principal_id  = each.value.service_principal_id
  service_principal_key = each.value.service_principal_key
  tenant                = each.value.tenant

  timeouts {
    create = try(each.value.timeouts.create, "30m")
    update = try(each.value.timeouts.update, "30m")
    read   = try(each.value.timeouts.read, "5m")
    delete = try(each.value.timeouts.delete, "30m")
  }
}
