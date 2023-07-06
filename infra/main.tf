module "initTf" {
  source              = "./modules/initTf"

  resource_group_name = "rg-terraform"
  resource_group_location = var.location
  storage_account_name_prefix = "tfState"
  container_name      = "tfstates"
  env                 = var.env
}

terraform {
  backend "azurerm" {
    resource_group_name  = "rg-terraform"
    storage_account_name = module.initTf.storage_account_name
    container_name       = "tfstates"
    key                  = "dev.terraform.tfstate"
  }
}
