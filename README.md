Create an Azure SQL Database
==============================================================================

This Terraform create a basic Azure SQL Database.

Module Input Variables 
----------------------

- `prefix` - The prefix that will be used for all resources that will be created by this module.
- `location` - The Azure location where the resources will be created.
- `server_version` - The version for the database server. Default is 12.0. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server).
- `db_name` - The name of the database that will be created.
- `db_edition` - The edition of the database that will be created. See https://docs.microsoft.com/en-gb/azure/sql-database/sql-database-service-tiers for more information.
- `service_objective_name` - The performance level for the database that will be created. The default value is Basic. See https://docs.microsoft.com/en-gb/azure/sql-database/sql-database-service-tiers for a list of acceptable values.
- `collation` - The collation to use with the database that will be created. Default is SQL_Latin1_General_CP1_CI_AS.
- `sql_admin_username` - The administrator user name for the database that will be created.
- `sql_admin_password` - The administrator password for the database that will be created.
- `start_ip_address` - The start IP address to use for your database firewall rule.
- `end_ip_address` - The end IP address to use for your database firewall rule.
- `tags` - A map of the tags to use on the resources that are deployed with this module.

Usage
-----

```hcl
module "sql-database" {
  source              = "terraform-azurerm-database/"
  prefix              = "myapp"
  location            = "westus"
  db_name             = "mydatabase"
  sql_admin_username  = "mradministrator"
  sql_password        = "P@ssw0rd12345!"

  tags             = {
                        environment = "dev"
                        costcenter  = "it"
                      }
  
}
```

Outputs
=======

- `database_name` - The name of the Azure SQL Database created
- `sql_server_name` - The name of the Azure SQL Database created
- `sql_server_location` - Location of the Azure SQL Database created
- `sql_server_version` - Version of the Azure SQL Database created
- `sql_server_fqdn` - Fully Qualified Domain Name (FQDN) of the Azure SQL Database created.
- `connection_string` - Connection string for the Azure SQL Database created.

Authors
=======
Originally created by [James Earle](http://github.com/JamesEarle)