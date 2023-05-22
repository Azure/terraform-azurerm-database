# terraform-azurerm-database

## Create an Azure SQL Database

This Terraform module creates a basic Azure SQL Database.

## Usage

```hcl
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
```

## Pre-Commit & Pr-Check & Test

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We assumed that you have setup service principal's credentials in your environment variables like below:

```shell
export ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
export ARM_TENANT_ID="<azure_subscription_tenant_id>"
export ARM_CLIENT_ID="<service_principal_appid>"
export ARM_CLIENT_SECRET="<service_principal_password>"
```

On Windows Powershell:

```shell
$env:ARM_SUBSCRIPTION_ID="<azure_subscription_id>"
$env:ARM_TENANT_ID="<azure_subscription_tenant_id>"
$env:ARM_CLIENT_ID="<service_principal_appid>"
$env:ARM_CLIENT_SECRET="<service_principal_password>"
```

We provide a docker image to run the pre-commit checks and tests for you: `mcr.microsoft.com/azterraform:latest`

To run the pre-commit task, we can run the following command:

```shell
$ docker run --rm -v $(pwd):/src -w /src mcr.microsoft.com/azterraform:latest make pre-commit
```

On Windows Powershell:

```shell
$ docker run --rm -v ${pwd}:/src -w /src mcr.microsoft.com/azterraform:latest make pre-commit
```

In pre-commit task, we will:

1. Run `terraform fmt -recursive` command for your Terraform code.
2. Run `terrafmt fmt -f` command for markdown files and go code files to ensure that the Terraform code embedded in these files are well formatted.
3. Run `go mod tidy` and `go mod vendor` for test folder to ensure that all the dependencies have been synced.
4. Run `gofmt` for all go code files.
5. Run `gofumpt` for all go code files.
6. Run `terraform-docs` on `README.md` file, then run `markdown-table-formatter` to format markdown tables in `README.md`.

Then we can run the pr-check task to check whether our code meets our pipeline's requirement(We strongly recommend you run the following command before you commit):

```shell
$ docker run --rm -v $(pwd):/src -w /src mcr.microsoft.com/azterraform:latest make pr-check
```

On Windows Powershell:

```shell
$ docker run --rm -v ${pwd}:/src -w /src mcr.microsoft.com/azterraform:latest make pr-check
```

To run the e2e-test, we can run the following command:

```text
docker run --rm -v $(pwd):/src -w /src -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

On Windows Powershell:

```text
docker run --rm -v ${pwd}:/src -w /src -e ARM_SUBSCRIPTION_ID -e ARM_TENANT_ID -e ARM_CLIENT_ID -e ARM_CLIENT_SECRET mcr.microsoft.com/azterraform:latest make e2e-test
```

#### Prerequisites

- [Docker](https://www.docker.com/community-edition#/download)

## Authors

Originally created by [James Earle](http://github.com/JamesEarle)

## License

[MIT](LICENSE)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name                                                                      | Version |
|---------------------------------------------------------------------------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2  |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm)       | ~>3.0   |

## Providers

| Name                                                          | Version |
|---------------------------------------------------------------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~>3.0   |

## Modules

No modules.

## Resources

| Name                                                                                                                              | Type     |
|-----------------------------------------------------------------------------------------------------------------------------------|----------|
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group)       | resource |
| [azurerm_sql_database.db](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_database)           | resource |
| [azurerm_sql_firewall_rule.fw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_firewall_rule) | resource |
| [azurerm_sql_server.server](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/sql_server)           | resource |

## Inputs

| Name                                                                                                     | Description                                                                                                                                                                      | Type          | Default                                            | Required |
|----------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------|----------------------------------------------------|:--------:|
| <a name="input_collation"></a> [collation](#input\_collation)                                            | The collation for the database. Default is SQL\_Latin1\_General\_CP1\_CI\_AS                                                                                                     | `string`      | `"SQL_Latin1_General_CP1_CI_AS"`                   |    no    |
| <a name="input_db_edition"></a> [db\_edition](#input\_db\_edition)                                       | The edition of the database to be created.                                                                                                                                       | `string`      | `"Basic"`                                          |    no    |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name)                                                | The name of the database to be created.                                                                                                                                          | `string`      | n/a                                                |   yes    |
| <a name="input_end_ip_address"></a> [end\_ip\_address](#input\_end\_ip\_address)                         | Defines the end IP address used in your database firewall rule.                                                                                                                  | `string`      | `"0.0.0.0"`                                        |    no    |
| <a name="input_location"></a> [location](#input\_location)                                               | The location/region where the database and server are created. Changing this forces a new resource to be created.                                                                | `string`      | n/a                                                |   yes    |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name)          | Default resource group name that the database will be created in.                                                                                                                | `string`      | `"myapp-rg"`                                       |    no    |
| <a name="input_server_version"></a> [server\_version](#input\_server\_version)                           | The version for the database server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server).                                                                           | `string`      | `"12.0"`                                           |    no    |
| <a name="input_service_objective_name"></a> [service\_objective\_name](#input\_service\_objective\_name) | The performance level for the database. For the list of acceptable values, see https://docs.microsoft.com/en-gb/azure/sql-database/sql-database-service-tiers. Default is Basic. | `string`      | `"Basic"`                                          |    no    |
| <a name="input_sql_admin_username"></a> [sql\_admin\_username](#input\_sql\_admin\_username)             | The administrator username of the SQL Server.                                                                                                                                    | `string`      | n/a                                                |   yes    |
| <a name="input_sql_password"></a> [sql\_password](#input\_sql\_password)                                 | The administrator password of the SQL Server.                                                                                                                                    | `string`      | n/a                                                |   yes    |
| <a name="input_start_ip_address"></a> [start\_ip\_address](#input\_start\_ip\_address)                   | Defines the start IP address used in your database firewall rule.                                                                                                                | `string`      | `"0.0.0.0"`                                        |    no    |
| <a name="input_tags"></a> [tags](#input\_tags)                                                           | The tags to associate with your network and subnets.                                                                                                                             | `map(string)` | <pre>{<br>  "tag1": "",<br>  "tag2": ""<br>}</pre> |    no    |
| <a name="input_tracing_tags_enabled"></a> [tracing\_tags\_enabled](#input\_tracing\_tags\_enabled)       | Whether enable tracing tags that generated by BridgeCrew Yor.                                                                                                                    | `bool`        | `false`                                            |    no    |
| <a name="input_tracing_tags_prefix"></a> [tracing\_tags\_prefix](#input\_tracing\_tags\_prefix)          | Default prefix for generated tracing tags                                                                                                                                        | `string`      | `"avm_"`                                           |    no    |

## Outputs

| Name                                                                                              | Description                                                           |
|---------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------|
| <a name="output_connection_string"></a> [connection\_string](#output\_connection\_string)         | Connection string for the Azure SQL Database created.                 |
| <a name="output_database_name"></a> [database\_name](#output\_database\_name)                     | Database name of the Azure SQL Database created.                      |
| <a name="output_sql_server_fqdn"></a> [sql\_server\_fqdn](#output\_sql\_server\_fqdn)             | Fully Qualified Domain Name (FQDN) of the Azure SQL Database created. |
| <a name="output_sql_server_location"></a> [sql\_server\_location](#output\_sql\_server\_location) | Location of the Azure SQL Database created.                           |
| <a name="output_sql_server_name"></a> [sql\_server\_name](#output\_sql\_server\_name)             | Server name of the Azure SQL Database created.                        |
| <a name="output_sql_server_version"></a> [sql\_server\_version](#output\_sql\_server\_version)    | Version the Azure SQL Database created.                               |
<!-- END_TF_DOCS -->
