variable "db_name" {
  type    = string
  default = "mydatabase"
}

variable "end_ip_address" {
  type    = string
  default = "255.255.255.255"
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "resource_group_name" {
  type    = string
  default = "mssqlResourceGroup"
}

variable "sql_admin_username" {
  type    = string
  default = "azureuser"
}

variable "start_ip_address" {
  type    = string
  default = "0.0.0.0"
}
