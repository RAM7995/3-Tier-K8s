terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "resource_group_name" {
  type    = string
  default = "rg-demo"
}

variable "location" {
  type    = string
  default = "eastus"
}

variable "postgres_admin_login" {
  type    = string
  default = "pgadmin"
}

variable "postgres_admin_password" {
  type      = string
  default   = "P@ssw0rd1234!"
  sensitive = true
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_postgresql_flexible_server" "main" {
  name                   = "pgflex-${var.resource_group_name}"
  resource_group_name    = azurerm_resource_group.main.name
  location               = azurerm_resource_group.main.location
  version                = "13"
  administrator_login    = var.postgres_admin_login
  administrator_password = var.postgres_admin_password
  zone                   = "1"
  storage_mb             = 32768
  sku_name               = "GP_Standard_D2s_v3"
  backup_retention_days  = 7

  tags = {
    environment = "dev"
  }
}
