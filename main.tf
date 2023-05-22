resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.resource_group_name
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "8ed5d8395352e4f4c2fcf62ba8238814d013f82c"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-05-22 01:12:30"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-database"
    avm_yor_trace            = "04f48d0d-2dcd-4a05-ace8-208c9eb9acf4"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
}

resource "azurerm_sql_database" "db" {
  location                         = var.location
  name                             = var.db_name
  resource_group_name              = azurerm_resource_group.rg.name
  server_name                      = azurerm_sql_server.server.name
  collation                        = var.collation
  create_mode                      = "Default"
  edition                          = var.db_edition
  requested_service_objective_name = var.service_objective_name
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "8ed5d8395352e4f4c2fcf62ba8238814d013f82c"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-05-22 01:12:30"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-database"
    avm_yor_trace            = "1e70abe8-a70e-455c-a19b-7536d2d73f89"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
}

resource "azurerm_sql_server" "server" {
  #checkov:skip=CKV2_AZURE_7:We don't change tf config for now
  #checkov:skip=CKV2_AZURE_2:We don't change tf config for now
  #checkov:skip=CKV_AZURE_24:We don't change tf config for now
  #checkov:skip=CKV_AZURE_23:We don't change tf config for now
  #checkov:skip=CKV2_AZURE_6:We don't change tf config for now
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_password
  location                     = var.location
  name                         = "${var.db_name}-sqlsvr"
  resource_group_name          = azurerm_resource_group.rg.name
  version                      = var.server_version
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "8ed5d8395352e4f4c2fcf62ba8238814d013f82c"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2023-05-22 01:12:30"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-database"
    avm_yor_trace            = "1542e4cc-803b-4341-a964-3ada00406a2c"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
}

resource "azurerm_sql_firewall_rule" "fw" {
  #checkov:skip=CKV_AZURE_11:We don't change tf config for now
  end_ip_address      = var.end_ip_address
  name                = "${var.db_name}-fwrules"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.server.name
  start_ip_address    = var.start_ip_address
}

