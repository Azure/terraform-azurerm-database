resource "random_string" "name" {
  length  = 6
  upper   = false
  special = false
}

resource "random_password" "password" {
  length = 20
}

resource "azurerm_resource_group" "rg" {
  location = var.location
  name     = "${var.resource_group_name}-${random_string.name.result}"
}

data "azurerm_client_config" "current" {}

resource "azurerm_storage_account" "vulnerability_assessment" {
  account_replication_type = "GRS"
  account_tier             = "Standard"
  location                 = azurerm_resource_group.rg.location
  name                     = "va${random_string.name.result}"
  resource_group_name      = azurerm_resource_group.rg.name
}

resource "azurerm_storage_container" "vulnerability_assessment" {
  name                  = "va-container"
  storage_account_name  = azurerm_storage_account.vulnerability_assessment.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "vulnerability_assessment2" {
  name                  = "va-container2"
  storage_account_name  = azurerm_storage_account.vulnerability_assessment.name
  container_access_type = "private"
}

resource "azurerm_storage_account" "security_alert_policy" {
  account_replication_type = "GRS"
  account_tier             = "Standard"
  location                 = azurerm_resource_group.rg.location
  name                     = "sap${random_string.name.result}"
  resource_group_name      = azurerm_resource_group.rg.name
}

module "sql_database" {
  source                = "../.."
  create_resource_group = false
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  db_name               = "${var.db_name}-${random_string.name.result}"
  sql_admin_username    = var.sql_admin_username
  sql_password          = random_password.password.result
  sql_aad_administrator = {
    login     = "sqladmin"
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = coalesce(var.msi_id, data.azurerm_client_config.current.object_id)
  }
  start_ip_address                                               = var.start_ip_address
  end_ip_address                                                 = var.end_ip_address
  mssql_server_security_alert_policy_storage_account_access_keys = {
    sap = azurerm_storage_account.security_alert_policy.primary_access_key
  }
  mssql_server_vulnerability_assessment_storage_account_keys = {
    sap_default = {
      access_key = azurerm_storage_account.vulnerability_assessment.primary_access_key
    }
  }
  mssql_server_security_alert_policies = {
    sap = {
      state                     = "Enabled"
      storage_endpoint          = azurerm_storage_account.security_alert_policy.primary_blob_endpoint
      retention_days            = 20
      vulnerability_assessments = {
        default = {
          storage_container_path = "${azurerm_storage_account.vulnerability_assessment.primary_blob_endpoint}${azurerm_storage_container.vulnerability_assessment.name}/"
          recurring_scans        = {
            enabled                   = true
            email_subscription_admins = true
            emails                    = [
              "email@example1.com",
              "email@example2.com"
            ]
          }
        }
      }
    }
    sap2 = {
      state                     = "Enabled"
      retention_days            = 20
      vulnerability_assessments = {
        default = {
          storage_container_path = "${azurerm_storage_account.vulnerability_assessment.primary_blob_endpoint}${azurerm_storage_container.vulnerability_assessment2.name}/"
          recurring_scans        = {
            enabled                   = true
            email_subscription_admins = true
            emails                    = [
              "email2@example1.com",
              "email2@example2.com"
            ]
          }
        }
      }
    }
  }
}
