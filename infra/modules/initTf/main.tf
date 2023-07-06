terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_string" "resource_code" {
  length  = 5
  special = false
  upper   = false
}

resource "azurerm_resource_group" "tf_resource_group" {
  name     = var.resource_group_name
  location = var.resource_group_location
}


resource "azurerm_storage_account" "tf_storage_account" {
  name                     = var.storage_account_name_prefix + random_string.resource_code.result
  resource_group_name      = var.resource_group_name
  location                 = var.resource_group_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = false
  min_tls_version          = "TLS1_2"

  tags = {
    environment = var.env
  }
}

resource "azurerm_storage_container" "tf_container" {
  name                  = var.container_name
  storage_account_name  = var.storage_account_name_prefix + random_string.resource_code.result
  container_access_type = "private"
}
