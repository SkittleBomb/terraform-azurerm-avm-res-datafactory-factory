output "private_endpoints" {
  description = "A map of private endpoints. The map key is the supplied input to var.private_endpoints. The map value is the entire azurerm_private_endpoint resource."
  value       = azurerm_private_endpoint.this
}

# Module owners should include the full resource via a 'resource' output
# https://azure.github.io/Azure-Verified-Modules/specs/terraform/#id-tffr2---category-outputs---additional-terraform-outputs
output "resource" {
  description = "This is the full output for the resource."
  value       = azurerm_data_factory.this
}

output "linked_service_data_lake_storage_gen2" {
  description = "A map of Data Factory Linked Service Data Lake Storage Gen2 resources. The map key is the supplied input to var.linked_service_data_lake_storage_gen2. The map value is the entire azurerm_data_factory_linked_service_data_lake_storage_gen2 resource."
  value       = azurerm_data_factory_linked_service_data_lake_storage_gen2.this
}

output "linked_service_azure_databricks" {
  description = "A map of Data Factory Linked Service Azure Databricks resources."
  value       = azurerm_data_factory_linked_service_azure_databricks.this
}

output "linked_custom_service" {
  description = "A map of Data Factory Linked Custom Service resources."
  value       = azurerm_data_factory_linked_custom_service.this
}

output "linked_service_azure_blob_storage" {
  description = "A map of Data Factory Linked Service Azure Blob Storage resources."
  value       = azurerm_data_factory_linked_service_azure_blob_storage.this
}

output "linked_service_key_vault" {
  description = "A map of Data Factory Linked Service Key Vault resources."
  value       = azurerm_data_factory_linked_service_key_vault.this
}