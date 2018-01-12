module "sql-database" {
  source              = "Azure/database/azurerm"
  resource_group_name = "myapp"
  location            = "westus"
  db_name             = "mydatabase"
  sql_admin_username  = "mradministrator"
  sql_password        = "P@ssw0rd12345!"

  tags = {
    environment = "dev"
    costcenter  = "it"
  }
}
