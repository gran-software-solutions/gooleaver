resource "azurerm_container_registry" "acr_gooleaver" {
  name                = "acrGooleaver"
  location            = azurerm_resource_group.rg_gooleaver.location
  resource_group_name = azurerm_resource_group.rg_gooleaver.name
  sku                 = "Basic"
}

resource "azuread_application" "app_github" {
  display_name = "Github"
}

resource "azuread_service_principal" "sp_github" {
  application_id = azuread_application.app_github.application_id
}

resource "azuread_service_principal_password" "sp_pass_github" {
  service_principal_id = azuread_service_principal.sp_github.object_id
}

resource "azurerm_role_assignment" "sp_to_acr" {
  principal_id         = azuread_service_principal.sp_github.object_id
  scope                = azurerm_container_registry.acr_gooleaver.id
  role_definition_name = "AcrPush"
}

resource "azurerm_key_vault_secret" "kv_secret_github_client_secret" {
  key_vault_id = azurerm_key_vault.gooleaver_keyvault.id
  name         = "githubClientSecret"
  value        = azuread_service_principal_password.sp_pass_github.value
}

resource "azurerm_key_vault_secret" "kv_secret_github_client_id" {
  key_vault_id = azurerm_key_vault.gooleaver_keyvault.id
  name         = "githubClientId"
  value        = azuread_application.app_github.application_id
}
