variable "resource_group_name" {
  type    = string
  default = "mssqlResourceGroup"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "db_name" {
  type    = string
  default = "mydatabase"
}

variable "sql_admin_username" {
  type    = string
  default = "azureuser"
}

variable "start_ip_address" {
  type    = string
  default = "0.0.0.0"
}

variable "end_ip_address" {
  type    = string
  default = "255.255.255.255"
}
