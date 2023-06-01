moved {
  from = azurerm_resource_group.rg
  to   = azurerm_resource_group.rg[0]
}

resource "azurerm_resource_group" "rg" {
  count = var.create_resource_group ? 1 : 0

  location = var.location
  name     = var.resource_group_name
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "2763e5639b42d96382eb4e372bef3a0475128aba"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-05-30 07:48:14"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-database"
    avm_yor_trace            = "44b1d744-f34e-422b-91d8-3d853bc3645b"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "rg"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
}

locals {
  resource_group_name = try(azurerm_resource_group.rg[0].name, var.resource_group_name)
}

resource "azurerm_sql_database" "db" {
  location                         = var.location
  name                             = var.db_name
  resource_group_name              = local.resource_group_name
  server_name                      = azurerm_sql_server.server.name
  collation                        = var.collation
  create_mode                      = "Default"
  edition                          = var.db_edition
  requested_service_objective_name = var.service_objective_name
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "2763e5639b42d96382eb4e372bef3a0475128aba"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-05-30 07:48:14"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-database"
    avm_yor_trace            = "fbbc3e92-f5fc-4173-bd85-58423189e5d8"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "db"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
}

resource "azurerm_sql_server" "server" {
  #checkov:skip=CKV_AZURE_24:We don't change tf config for now
  #checkov:skip=CKV_AZURE_23:We don't change tf config for now
  #checkov:skip=CKV2_AZURE_6:We don't change tf config for now
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_password
  location                     = var.location
  name                         = "${var.db_name}-sqlsvr"
  resource_group_name          = local.resource_group_name
  version                      = var.server_version
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "2763e5639b42d96382eb4e372bef3a0475128aba"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-05-30 07:48:14"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-database"
    avm_yor_trace            = "53033ef9-ced3-4a5f-a17b-d56cf9817bea"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "server"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
}

resource "azurerm_sql_firewall_rule" "fw" {
  #checkov:skip=CKV_AZURE_11:We don't change tf config for now
  end_ip_address      = var.end_ip_address
  name                = "${var.db_name}-fwrules"
  resource_group_name = local.resource_group_name
  server_name         = azurerm_sql_server.server.name
  start_ip_address    = var.start_ip_address
}

resource "azurerm_sql_active_directory_administrator" "aad_admin" {
  count = var.sql_aad_administrator == null ? 0 : 1

  login                       = var.sql_aad_administrator.login
  object_id                   = var.sql_aad_administrator.object_id
  resource_group_name         = local.resource_group_name
  server_name                 = azurerm_sql_server.server.name
  tenant_id                   = var.sql_aad_administrator.tenant_id
  azuread_authentication_only = var.sql_aad_administrator.azuread_authentication_only
}

resource "azurerm_mssql_server_security_alert_policy" "this" {
  for_each = var.mssql_server_security_alert_policies

  resource_group_name        = local.resource_group_name
  server_name                = azurerm_sql_server.server.name
  state                      = each.value.state
  disabled_alerts            = each.value.disabled_alerts
  email_account_admins       = each.value.email_account_admins
  email_addresses            = each.value.email_addresses
  retention_days             = each.value.retention_days
  storage_account_access_key = lookup(var.mssql_server_security_alert_policy_storage_account_access_keys, each.key, null)
  storage_endpoint           = each.value.storage_endpoint

  lifecycle {
    precondition {
      condition     = each.value.storage_endpoint == null || try(var.mssql_server_security_alert_policy_storage_account_access_keys[each.key], null) != null
      error_message = "Once `storage_endpoint` has been set, a corresponding `var.mssql_server_security_alert_policy_storage_account_access_keys` record must be set too."
    }
  }
}

resource "azurerm_mssql_server_vulnerability_assessment" "this" {
  for_each = local.vulnerability_assessments

  server_security_alert_policy_id = azurerm_mssql_server_security_alert_policy.this[split("_", each.key)[0]].id
  storage_container_path          = each.value.storage_container_path
  storage_account_access_key      = try(var.mssql_server_vulnerability_assessment_storage_account_keys[each.key].access_key, null)
  storage_container_sas_key       = try(var.mssql_server_vulnerability_assessment_storage_account_keys[each.key].sas_key, null)

  dynamic "recurring_scans" {
    for_each = each.value.recurring_scans == null ? [] : ["recurring_scans"]

    content {
      email_subscription_admins = each.value.recurring_scans.email_subscription_admins
      emails                    = each.value.recurring_scans.emails
      enabled                   = each.value.recurring_scans.enabled
    }
  }
}