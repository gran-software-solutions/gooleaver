resource "azurerm_kubernetes_cluster" "aks_gooleaver" {
  name                = "aksGooleaver"
  location            = azurerm_resource_group.rg_gooleaver.location
  resource_group_name = azurerm_resource_group.rg_gooleaver.name
  dns_prefix          = "gooleaver"

  default_node_pool {
    name    = "default"
    vm_size = "standard_a2_v2"
    node_count = 1
  }

  identity {
    type = "SystemAssigned"
  }
}
