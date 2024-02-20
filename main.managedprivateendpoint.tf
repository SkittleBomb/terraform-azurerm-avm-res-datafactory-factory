resource "azurerm_data_factory_managed_private_endpoint" "this" {
  for_each = var.managed_private_endpoint

  name               = each.value.name
  data_factory_id    = azurerm_data_factory.this.id
  target_resource_id = each.value.target_resource_id
  subresource_name   = each.value.subresource_name
  fqdns              = each.value.fqdns

  timeouts {
    create = try(each.value.timeouts.create, "30m")
    read   = try(each.value.timeouts.read, "5m")
    delete = try(each.value.timeouts.delete, "30m")
  }
}