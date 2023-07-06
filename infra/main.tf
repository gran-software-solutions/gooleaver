terraform {
  required_providers {
    azurerm = { }
  }

  backend "azurerm" { }
}

resource "azurerm_resource_group" "rg_gooleaver" {
  name     = "rgGooleaver"
  location = "Germany West Central"
}
