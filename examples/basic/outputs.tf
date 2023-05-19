output "database_name" {
  value = module.sql_database.database_name
}

output "sql_server_name" {
  value = module.sql_database.sql_server_name
}

output "sql_server_fqdn" {
  value = module.sql_database.sql_server_fqdn
}

output "sql_admin_username" {
  value = var.sql_admin_username
}

output "sql_password" {
  sensitive = true
  value     = random_password.password.result
}
