terraform {
  required_providers {
    azurerm = { }
    azuread = { }
  }

  backend "azurerm" { }
}

provider "azurerm" {
  features {}
}

provider "azuread" { }

resource "azurerm_resource_group" "rg_gooleaver" {
  name     = "rgGooleaver"
  location = var.location
}

resource "random_integer" "random_num" {
  min = 1
  max = 50000
}

resource "azurerm_key_vault" "gooleaver_keyvault" {
  location            = var.location
  name                = format("%s%s", "gooleaver-keyvault", random_integer.random_num.result)
  resource_group_name = azurerm_resource_group.rg_gooleaver.name
  sku_name            = "standard"
  tenant_id           = var.tenant_id
  enable_rbac_authorization = true
}