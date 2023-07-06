variable "resource_group_name" {
  type = string
  description = "The name of the resource group in which terraform states will be stored."
}

variable "resource_group_location" {
  type = string
  description = "The location of the resource group in which terraform states will be stored."
}

variable "storage_account_name_prefix" {
  type = string
  description = "The name prefix of the storage account in which terraform states will be stored."
}

variable "container_name" {
  type = string
  description = "The name of the container in which terraform states will be stored."
}

variable "env" {
  type = string
  description = "Environment Name"
}


