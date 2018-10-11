# provider "azurerm" {
#   subscription_id = "REPLACE-WITH-YOUR-SUBSCRIPTION-ID"
#   client_id       = "REPLACE-WITH-YOUR-CLIENT-ID"
#   client_secret   = "REPLACE-WITH-YOUR-CLIENT-SECRET"
#   tenant_id       = "REPLACE-WITH-YOUR-TENANT-ID"
# }

resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
}

resource "azurerm_sql_database" "db" {
  count                            = "${length(var.db_names)}"
  name                             = "${var.db_names[count.index]}"
  resource_group_name              = "${azurerm_resource_group.rg.name}"
  location                         = "${var.location}"
  edition                          = "${var.db_edition}"
  collation                        = "${var.collation}"
  server_name                      = "${azurerm_sql_server.server.name}"
  create_mode                      = "Default"
  requested_service_objective_name = "${var.service_objective_name}"
  tags                             = "${var.tags}"
}

resource "azurerm_sql_server" "server" {
  name                         = "${var.server_name}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  location                     = "${var.location}"
  version                      = "${var.server_version}"
  administrator_login          = "${var.sql_admin_username}"
  administrator_login_password = "${var.sql_password}"
  tags                         = "${var.tags}"
}

resource "azurerm_sql_firewall_rule" "fw" {
  name                = "${azurerm_sql_server.server.name}-fwrules"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  server_name         = "${azurerm_sql_server.server.name}"
  start_ip_address    = "${var.start_ip_address}"
  end_ip_address      = "${var.end_ip_address}"
}
