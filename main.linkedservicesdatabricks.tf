resource "azurerm_data_factory_linked_service_azure_databricks" "this" {
  for_each = var.linked_service_azure_databricks

  name            = each.value.name
  data_factory_id = azurerm_data_factory.this.id
  adb_domain      = each.value.adb_domain
  access_token    = try(each.value.access_token, null)

  dynamic "key_vault_password" {
    for_each = each.value.key_vault_password != null ? [each.value.key_vault_password] : []
    content {
      linked_service_name = key_vault_password.value.linked_service_name
      secret_name         = key_vault_password.value.secret_name
    }
  }

  msi_work_space_resource_id = try(each.value.msi_work_space_resource_id, null)
  existing_cluster_id        = try(each.value.existing_cluster_id, null)

  dynamic "instance_pool" {
    for_each = each.value.instance_pool != null ? [each.value.instance_pool] : []
    content {
      instance_pool_id      = instance_pool.value.instance_pool_id
      cluster_version       = instance_pool.value.cluster_version
      min_number_of_workers = instance_pool.value.min_number_of_workers
      max_number_of_workers = instance_pool.value.max_number_of_workers
    }
  }

  dynamic "new_cluster_config" {
    for_each = each.value.new_cluster_config != null ? [each.value.new_cluster_config] : []
    content {
      cluster_version             = new_cluster_config.value.cluster_version
      node_type                   = new_cluster_config.value.node_type
      custom_tags                 = new_cluster_config.value.custom_tags
      driver_node_type            = new_cluster_config.value.driver_node_type
      init_scripts                = new_cluster_config.value.init_scripts
      log_destination             = new_cluster_config.value.log_destination
      max_number_of_workers       = new_cluster_config.value.max_number_of_workers
      min_number_of_workers       = new_cluster_config.value.min_number_of_workers
      spark_config                = new_cluster_config.value.spark_config
      spark_environment_variables = new_cluster_config.value.spark_environment_variables
    }
  }

  additional_properties    = try(each.value.additional_properties, null)
  annotations              = try(each.value.annotations, null)
  description              = try(each.value.description, null)
  integration_runtime_name = try(each.value.integration_runtime_name, null)
  parameters               = try(each.value.parameters, null)

  timeouts {
    create = try(each.value.timeouts.create, "30m")
    update = try(each.value.timeouts.update, "30m")
    read   = try(each.value.timeouts.read, "5m")
    delete = try(each.value.timeouts.delete, "30m")
  }
}
