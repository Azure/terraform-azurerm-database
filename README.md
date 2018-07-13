# terraform-azurerm-database

[![Build Status](https://travis-ci.org/foreverXZC/terraform-azurerm-database.svg?branch=master)](https://travis-ci.org/foreverXZC/terraform-azurerm-database)

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

  tags             = {
                        environment = "dev"
                        costcenter  = "it"
                      }
  
}
```

## Test

### Configurations

- [Configure Terraform for Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/terraform-install-configure)

We provide 2 ways to build, run, and test module on local dev box:

### Native(Mac/Linux)

#### Prerequisites

- [Ruby **(~> 2.3)**](https://www.ruby-lang.org/en/downloads/)
- [Bundler **(~> 1.15)**](https://bundler.io/)
- [Terraform **(~> 0.11.0)**](https://www.terraform.io/downloads.html)

#### Environment setup

We provide simple script to quickly set up module development environment:

```sh

curl -sSL https://raw.githubusercontent.com/Azure/terramodtest/master/tool/env_setup.sh | sudo bash
```

#### Run test

Then simply run it in local shell:

```sh

bundle install
rake build
rake e2e
```

### Docker

We provide Dockerfile to build and run module development environment locally:

#### Prerequisites (Docker)

- [Docker](https://www.docker.com/community-edition#/download)

#### Build the image

```sh
docker build --build-arg BUILD_ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID --build-arg BUILD_ARM_CLIENT_ID=$ARM_CLIENT_ID --build-arg BUILD_ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET --build-arg BUILD_ARM_TENANT_ID=$ARM_TENANT_ID -t azure-database-module .
```

#### Run test (Docker)

```sh
docker run -t azure-database-module rake full
```

## Authors

Originally created by [James Earle](http://github.com/JamesEarle)
