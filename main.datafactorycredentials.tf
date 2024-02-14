resource "azurerm_data_factory_credential_user_managed_identity" "this" {
  for_each        = var.data_factory_credentials
  name            = each.value.user_assigned_identity_name
  description     = each.value.credential_description
  data_factory_id = azurerm_data_factory.this.id
  identity_id     = each.value.user_assigned_identity_id

  annotations = each.value.credential_annotations
}
