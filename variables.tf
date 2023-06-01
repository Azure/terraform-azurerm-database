variable "db_name" {
  type        = string
  description = "The name of the database to be created."
}

variable "location" {
  type        = string
  description = "The location/region where the database and server are created. Changing this forces a new resource to be created."
}

variable "sql_admin_username" {
  type        = string
  description = "The administrator username of the SQL Server."
}

variable "sql_password" {
  type        = string
  description = "The administrator password of the SQL Server."
  sensitive   = true
}

variable "collation" {
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
  description = "The collation for the database. Default is SQL_Latin1_General_CP1_CI_AS"
}

variable "create_resource_group" {
  type        = bool
  default     = true
  description = "Create a new resource group with name `var.resource_group_name`, or just use it as resource group's name. Default to `true`. Changing this forces a new resource to be created."
}

variable "db_edition" {
  type        = string
  default     = "Basic"
  description = "The edition of the database to be created."
}

variable "end_ip_address" {
  type        = string
  default     = "0.0.0.0"
  description = "Defines the end IP address used in your database firewall rule."
}

variable "mssql_server_security_alert_policies" {
  type = map(object({
    state                = string
    disabled_alerts      = optional(set(string))
    email_account_admins = optional(bool, false)
    email_addresses      = optional(set(string))
    retention_days       = optional(number, 0)
    storage_endpoint     = optional(string)
    vulnerability_assessments = optional(map(object({
      storage_container_path = string
      recurring_scans = optional(object({
        email_subscription_admins = optional(bool, false)
        emails                    = optional(list(string))
        enabled                   = optional(bool, false)
      }))
    })))
  }))
  default     = null
  description = <<-EOT
  map(object({
    state                = (Required) Specifies the state of the policy, whether it is enabled or disabled or a policy has not been applied yet on the specific database server. Possible values are `Disabled`, `Enabled` and `New`.
    disabled_alerts      = (Optional) Specifies an array of alerts that are disabled. Allowed values are: `Sql_Injection`, `Sql_Injection_Vulnerability`, `Access_Anomaly`, `Data_Exfiltration`, `Unsafe_Action`.
    email_account_admins = (Optional) Boolean flag which specifies if the alert is sent to the account administrators or not. Defaults to `false`.
    email_addresses      = (Optional) Specifies an array of email addresses to which the alert is sent.
    retention_days       = (Optional) Specifies the number of days to keep in the Threat Detection audit logs. Defaults to `0`.
    storage_endpoint     = (Optional) Specifies the blob storage endpoint (e.g. <https://example.blob.core.windows.net>). This blob storage will hold all Threat Detection audit logs.
    vulnerability_assessments = map(object({
      storage_container_path = (Required) A blob storage container path to hold the scan results (e.g. <https://example.blob.core.windows.net/VaScans/>).
      recurring_scans = optional(object({
        email_subscription_admins = (Optional) Boolean flag which specifies if the schedule scan notification will be sent to the subscription administrators. Defaults to `false`.
        emails                    = (Optional) Specifies an array of email addresses to which the scan notification is sent.
        enabled                   = (Optional) Boolean flag which specifies if recurring scans is enabled or disabled. Defaults to `false`.
      }))
    }))
  }))
EOT
}

variable "mssql_server_security_alert_policy_storage_account_access_keys" {
  type        = map(string)
  default     = {}
  description = "(Optional) Specifies the identifier keys of the Threat Detection audit storage accounts. This is mandatory when you use storage_endpoint to specify a storage account blob endpoint."
  nullable    = false
  sensitive   = true

  validation {
    condition     = alltrue([for k, v in var.mssql_server_security_alert_policy_storage_account_access_keys : v != null && v != ""])
    error_message = "`var.mssql_server_security_alert_policy_storage_account_access_keys` cannot contain non-empty string"
  }
}

variable "mssql_server_vulnerability_assessment_storage_account_keys" {
  type = map(object({
    access_key = optional(string)
    sas_key    = optional(string)
  }))
  default     = {}
  nullable = false
  description = <<-EOT
  map(object({
    access_key =  (Optional) Specifies the identifier key of the storage account for vulnerability assessment scan results. If `storage_container_sas_key` isn't specified, `storage_account_access_key` is required. The `access_key` only applies if the storage account is not behind a virtual network or a firewall.
    sas_key = (Optional) A shared access signature (SAS Key) that has write access to the blob container specified in `storage_container_path` parameter. If `storage_account_access_key` isn't specified, `storage_container_sas_key` is required. The `sas_key` only applies if the storage account is not behind a virtual network or a firewall.
  }))
EOT
  sensitive   = true

  validation {
    condition     = alltrue([for k,v in var.mssql_server_vulnerability_assessment_storage_account_keys : can(coalesce(v.access_key, v.sas_key))])
    error_message = "All elements in `var.mssql_server_vulnerability_assessment_storage_account_keys` must set `access_key` or `sas_key`."
  }
}

variable "resource_group_name" {
  type        = string
  default     = "myapp-rg"
  description = "Default resource group name that the database will be created in."
}

variable "server_version" {
  type        = string
  default     = "12.0"
  description = "The version for the database server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
}

variable "service_objective_name" {
  type        = string
  default     = "Basic"
  description = "The performance level for the database. For the list of acceptable values, see https://docs.microsoft.com/en-gb/azure/sql-database/sql-database-service-tiers. Default is Basic."
}

variable "sql_aad_administrator" {
  type = object({
    login                       = string
    object_id                   = string
    tenant_id                   = string
    azuread_authentication_only = optional(bool)
  })
  default     = null
  description = <<-EOF
  object({
    login = (Required) The login name of the principal to set as the server administrator
    object_id = (Required) The ID of the principal to set as the server administrator
    tenant_id = (Required) The Azure Tenant ID
    azuread_authentication_only = (Optional) Specifies whether only AD Users and administrators can be used to login (`true`) or also local database users (`false`).
  })
EOF
}

variable "start_ip_address" {
  type        = string
  default     = "0.0.0.0"
  description = "Defines the start IP address used in your database firewall rule."
}

variable "tags" {
  type = map(string)
  default = {
    tag1 = ""
    tag2 = ""
  }
  description = "The tags to associate with your network and subnets."
}

# tflint-ignore: terraform_unused_declarations
variable "tracing_tags_enabled" {
  type        = bool
  default     = false
  description = "Whether enable tracing tags that generated by BridgeCrew Yor."
  nullable    = false
}

# tflint-ignore: terraform_unused_declarations
variable "tracing_tags_prefix" {
  type        = string
  default     = "avm_"
  description = "Default prefix for generated tracing tags"
  nullable    = false
}
