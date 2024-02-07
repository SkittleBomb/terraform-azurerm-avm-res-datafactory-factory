data "azurerm_resource_group" "parent" {
  count = var.location == null ? 1 : 0

  name = var.resource_group_name
}


resource "azurerm_data_factory" "this" {
  location                         = coalesce(var.location, local.resource_group_location)
  name                             = var.name
  resource_group_name              = var.resource_group_name
  customer_managed_key_id          = var.customer_managed_key_id
  customer_managed_key_identity_id = var.customer_managed_key_identity_id
  managed_virtual_network_enabled  = var.managed_virtual_network_enabled
  public_network_enabled           = var.public_network_enabled
  purview_id                       = var.purview_id
  tags                             = var.tags

  dynamic "github_configuration" {
    for_each = var.github_configuration != null ? [var.github_configuration] : []
    content {
      account_name       = github_configuration.value.account_name
      branch_name        = github_configuration.value.branch_name
      git_url            = github_configuration.value.git_url
      repository_name    = github_configuration.value.repository_name
      root_folder        = github_configuration.value.root_folder
      publishing_enabled = github_configuration.value.publishing_enabled
    }
  }
  dynamic "global_parameter" {
    for_each = var.global_parameter != null ? var.global_parameter : []
    content {
      name  = global_parameter.value["name"]
      type  = global_parameter.value["type"]
      value = global_parameter.value["value"]
    }
  }
  identity {
    type         = var.identity.type
    identity_ids = var.identity.identity_ids
  }
  dynamic "vsts_configuration" {
    for_each = var.vsts_configuration != null ? [var.vsts_configuration] : []
    content {
      account_name       = vsts_configuration.value.account_name
      branch_name        = vsts_configuration.value.branch_name
      project_name       = vsts_configuration.value.project_name
      repository_name    = vsts_configuration.value.repository_name
      root_folder        = vsts_configuration.value.root_folder
      tenant_id          = vsts_configuration.value.tenant_id
      publishing_enabled = vsts_configuration.value.publishing_enabled
    }
  }
}

# required AVM resources interfaces
resource "azurerm_management_lock" "this" {
  count = var.lock.kind != "None" ? 1 : 0

  lock_level = var.lock.kind
  name       = coalesce(var.lock.name, "lock-${var.name}")
  scope      = azurerm_data_factory.this.id
}

resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  principal_id                           = each.value.principal_id
  scope                                  = azurerm_data_factory.this.id
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  role_definition_id                     = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = strcontains(lower(each.value.role_definition_id_or_name), lower(local.role_definition_resource_substring)) ? null : each.value.role_definition_id_or_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each = var.diagnostic_settings

  name                           = each.value.name != null ? each.value.name : "diag-${var.name}"
  target_resource_id             = azurerm_data_factory.this.id
  eventhub_authorization_rule_id = each.value.event_hub_authorization_rule_resource_id
  eventhub_name                  = each.value.event_hub_name
  log_analytics_destination_type = each.value.log_analytics_destination_type
  log_analytics_workspace_id     = each.value.workspace_resource_id
  partner_solution_id            = each.value.marketplace_partner_resource_id
  storage_account_id             = each.value.storage_account_resource_id

  dynamic "enabled_log" {
    for_each = each.value.log_categories
    content {
      category = enabled_log.value
    }
  }
  dynamic "enabled_log" {
    for_each = each.value.log_groups
    content {
      category_group = enabled_log.value
    }
  }
  dynamic "metric" {
    for_each = each.value.metric_categories
    content {
      category = metric.value
    }
  }
}


resource "azurerm_data_factory_credential_user_managed_identity" "this" {
  for_each        = var.data_factory_credentials
  name            = each.value.user_assigned_identity_name
  description     = each.value.credential_description
  data_factory_id = azurerm_data_factory.this.id
  identity_id     = each.value.user_assigned_identity_id

  annotations = each.value.credential_annotations
}
