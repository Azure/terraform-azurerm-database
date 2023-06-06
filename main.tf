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
    avm_yor_trace            = "9b256485-35a5-491e-9918-de382aa82e16"
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
    avm_yor_trace            = "5e5b9c85-1dd9-466a-848d-5a35f2397676"
    } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/), (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_yor_name = "db"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
}

resource "azurerm_sql_server" "server" {
  #checkov:skip=CKV2_AZURE_2:We don't change tf config for now
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
    avm_yor_trace            = "6f19f205-825b-49b9-aa34-0660c139c85b"
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