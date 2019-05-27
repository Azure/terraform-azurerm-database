# terraform-azurerm-sqldatabase

[![Build Status](https://travis-ci.org/Azure/terraform-azurerm-sqldatabase.svg?branch=master)](https://travis-ci.org/Azure/terraform-azurerm-sqldatabase)

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

We provide 2 ways to build, run, and test the module on a local development machine.  [Native (Mac/Linux)](#native-maclinux) or [Docker](#docker).

### Native(Mac/Linux)

#### Prerequisites

- [Ruby **(~> 2.3)**](https://www.ruby-lang.org/en/downloads/)
- [Bundler **(~> 1.15)**](https://bundler.io/)
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
$ bundle install
$ rake build
$ rake e2e
```

### Docker

We provide a Dockerfile to build a new image based `FROM` the `microsoft/terraform-test` Docker hub image which adds additional tools / packages specific for this module (see Custom Image section).  Alternatively use only the `microsoft/terraform-test` Docker hub image [by using these instructions](https://github.com/Azure/terraform-test).

#### Prerequisites

- [Docker](https://www.docker.com/community-edition#/download)

#### Build the image

```sh
$ docker build --build-arg BUILD_ARM_SUBSCRIPTION_ID=$ARM_SUBSCRIPTION_ID --build-arg BUILD_ARM_CLIENT_ID=$ARM_CLIENT_ID --build-arg BUILD_ARM_CLIENT_SECRET=$ARM_CLIENT_SECRET --build-arg BUILD_ARM_TENANT_ID=$ARM_TENANT_ID -t azure-sqldatabase-module .
```

#### Run test (Docker)

This runs the build and unit tests:

```sh
$ docker run --rm azure-sqldatabase-module /bin/bash -c "bundle install && rake build"
```

This runs the end to end tests:

```sh
$ docker run --rm azure-sqldatabase-module /bin/bash -c "bundle install && rake e2e"
```

This runs the full tests:

```sh
$ docker run --rm azure-sqldatabase-module /bin/bash -c "bundle install && rake full"
```

## Authors

Originally created by [James Earle](http://github.com/JamesEarle)

## License

[MIT](LICENSE)
