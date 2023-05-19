resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = var.resource_group_name
  tags     = var.tags
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
  tags                             = var.tags
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
  tags                         = var.tags
}

resource "azurerm_sql_firewall_rule" "fw" {
  #checkov:skip=CKV_AZURE_11:We don't change tf config for now
  end_ip_address      = var.end_ip_address
  name                = "${var.db_name}-fwrules"
  resource_group_name = azurerm_resource_group.rg.name
  server_name         = azurerm_sql_server.server.name
  start_ip_address    = var.start_ip_address
}

