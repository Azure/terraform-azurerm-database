# Database Example

Use terraform azure module "database" to deploy a Microsoft SQL Dababase on azure. Then use terratest to connect to the database.

## Database

These terraform files enable users to deploy a Microsoft SQL Dababase on azure. Because database, server and firewall rules are all indicated in the module, it is possible to connect to the database from local and execute SQL commands. You can just test the infrastructure code manually without terratest.

## SQL

This folder only includes one file. First, the go test file uses terraform database module to deploy a database on azure. After that, it tries to connect to the database and execute several SQL commands to check whether the infrastructure runs correctly. Eventually, everything will be cleaned up after validation. You can write your own test code, for instance, to create an independent SQL file and use it when executing SQL commands.

## Running this module manually

1. Sign up for [Azure](https://portal.azure.com/).

1. Configure your Azure credentials. For instance, you may use [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and execute `az login`.

1. Install [Terraform](https://www.terraform.io/) and make sure it's on your `PATH`.

1. Direct to folder [database](/database/database) and run `terraform init`.

1. Run `terraform apply`.

1. When you're done, run `terraform destroy`.

## Running automated tests against this module

1. Sign up for [Azure](https://portal.azure.com/).

1. Configure your Azure credentials. For instance, you may use [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) and execute `az login`.

1. Install [Terraform](https://www.terraform.io/) and make sure it's on your `PATH`.

1. Install [Golang](https://golang.org/) and make sure this code is checked out into your `GOPATH`.

1. Direct to folder [sql](/database/sql) and make sure all packages are installed, such as executing `go get github.com/gruntwork-io/terratest/modules/terraform`, etc.

1. Run `go test`.

## Reference

[Terraform Azure Database Module](https://registry.terraform.io/modules/Azure/database/azurerm/)

[Database SQL Golang Document](https://golang.org/pkg/database/sql/)

[Go Database Tutorial](http://go-database-sql.org/)

[SQL Server Connection Example in Golang](https://mathaywardhill.com/2017/04/27/get-started-with-golang-and-sql-server-in-visual-studio-code/)

[Azure SQL Database Document](https://docs.microsoft.com/en-us/azure/sql-database/)