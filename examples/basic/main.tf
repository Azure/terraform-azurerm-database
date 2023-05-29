resource "random_id" "name" {
  byte_length = 8
}

resource "random_password" "password" {
  length = 20
}

data "azurerm_client_config" "current" {}

module "sql_database" {
  source              = "../.."
  resource_group_name = "${var.resource_group_name}-${random_id.name.hex}"
  location            = var.location
  db_name             = "${var.db_name}-${random_id.name.hex}"
  sql_admin_username  = var.sql_admin_username
  sql_password        = random_password.password.result
  sql_aad_administrator = {
    login     = "sqladmin"
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = coalesce(var.msi_id, data.azurerm_client_config.current.object_id)
  }
  start_ip_address = var.start_ip_address
  end_ip_address   = var.end_ip_address
}
