resource "azurerm_container_registry" "acr_gooleaver" {
  name                = "acrGooleaver"
  location            = azurerm_resource_group.rg_gooleaver.location
  resource_group_name = azurerm_resource_group.rg_gooleaver.name
  sku                 = "Basic"
}
