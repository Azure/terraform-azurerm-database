variable "resource_group_name" {
  default = "mssqlResourceGroup"
}

variable "location" {
  default = "westus2"
}

variable "db_name" {
  default = "mydatabase"
}

variable "sql_admin_username" {
  default = "azureuser"
}

variable "sql_password" {
  default = "P@ssw0rd12345!"
}

variable "start_ip_address" {
  default = "0.0.0.0"
}

variable "end_ip_address" {
  default = "255.255.255.255"
}
