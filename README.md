# terraform-azurerm-database

[![Build Status](https://travis-ci.org/Azure/terraform-azurerm-database.svg?branch=master)](https://travis-ci.org/Azure/terraform-azurerm-database)

## Create an Azure SQL Database

This Terraform module creates a set of Azure SQL Databases.

## Usage

```hcl
module "sql-database" {
  source              = "Azure/database/azurerm"
  resource_group_name = "myapp"
  location            = "westus"
  db_names            = ["mydatabase1","mydatabase2"]
  sql_admin_username  = "mradministrator"
  sql_password        = "P@ssw0rd12345!"

  tags             = {
                        environment = "dev"
                        costcenter  = "it"
                      }
  
}
```

## Test

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We provide 2 ways to build, run, and test the module on a local development machine.  [Native (Mac/Linux)](#native-maclinux) or [Docker](#docker).

### Native(Mac/Linux)

#### Prerequisites

- [Terraform **(~> 0.11.7)**](https://www.terraform.io/downloads.html)
- [Golang **(~> 1.10.3)**](https://golang.org/dl/)

#### Environment setup

We provide simple script to quickly set up module development environment:

```sh
$ curl -sSL https://raw.githubusercontent.com/Azure/terramodtest/master/tool/env_setup.sh | sudo bash
```

#### Run test

Then simply run it in local shell:

```sh
$ cd $GOPATH/src/{directory_name}/
$ ./test.sh full
```

### Docker

We provide a Dockerfile to build a new image based `FROM` the `microsoft/terraform-test` Docker hub image which adds additional tools / packages specific for this module (see Custom Image section).  Alternatively use only the `microsoft/terraform-test` Docker hub image [by using these instructions](https://github.com/Azure/terraform-test).

#### Prerequisites

- [Docker](https://www.docker.com/community-edition#/download)

#### Build the image

```sh
$ docker build -t azure-database-module .
```

#### Run test (Docker)

This runs the local validation:

```sh
$ docker run --rm azure-database-module /bin/bash -c "./test.sh validate"
```

This runs the full tests (deploys resources into your Azure subscription):

```sh
$ docker run -e "ARM_SUBSCRIPTION_ID=$AZURE_SUBSCRIPTION_ID" -e "ARM_CLIENT_ID=$AZURE_CLIENT_ID" -e "ARM_CLIENT_SECRET=$AZURE_CLIENT_SECRET" -e "ARM_TENANT_ID=$AZURE_TENANT_ID" -e "ARM_TEST_LOCATION=WestUS2" -e "ARM_TEST_LOCATION_ALT=EastUS" --rm azure-database-module bash -c "./test.sh full"
```


## Authors

Originally created by [James Earle](http://github.com/JamesEarle)

## License

[MIT](LICENSE)
