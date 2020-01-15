resource "random_id" "name" {
  byte_length = 8
}

module "sql-database" {
  source              = "../../"
  resource_group_name = "${var.resource_group_name}-${random_id.name.hex}"
  location            = "${var.location}"
  db_name             = "${var.db_name}-${random_id.name.hex}"
  sql_admin_username  = "${var.sql_admin_username}"
  sql_password        = "${var.sql_password}"
  start_ip_address    = "${var.start_ip_address}"
  end_ip_address      = "${var.end_ip_address}"
}
