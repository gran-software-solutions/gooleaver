#!/bin/bash

RESOURCE_GROUP_NAME=tfstate
# Storage account name must be between 3 and 24 characters in length and use numbers and lower-case letters only.
STORAGE_ACCOUNT_NAME=tfstate$RANDOM
CONTAINER_NAME=tfstate
# Key vault name needn't to be globally unique. Random is used here to avoid having naming conflicts with soft-deleted vaults during development.
KEY_VAULT_NAME=tfstate-key-vault-$RANDOM
LOCATION=germanywestcentral

# Create resource group
echo "Create a resource group:"
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create storage account - SKU Standard Locally Redundant Storage
echo "Create a storage account:"
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
echo "Create a blob container:"
az storage container create --auth-mode login --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME

echo "Creating the key vault:"
az keyvault create --name $KEY_VAULT_NAME --resource-group $RESOURCE_GROUP_NAME --location $LOCATION

ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)

SECRET_NAME="storage-account-key"

echo "Adding the Account Key to the Key Vault:"
az keyvault secret set --vault-name $KEY_VAULT_NAME --name $SECRET_NAME --value "$ACCOUNT_KEY" -o none

rm backend.conf
touch backend.conf
echo "resource_group_name=\"$RESOURCE_GROUP_NAME\"" >> backend.conf
echo "storage_account_name=\"$STORAGE_ACCOUNT_NAME\"" >> backend.conf
echo "container_name=\"$CONTAINER_NAME\"" >> backend.conf
echo "key=\"terraform.tfstate\"" >> backend.conf
