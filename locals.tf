locals {
  vulnerability_assessments = merge([
    for k, v in var.mssql_server_security_alert_policies : {
      for va_key, va in v.vulnerability_assessments : "${k}_${va_key}" => va
    } if v.vulnerability_assessments != null
  ]...)
}