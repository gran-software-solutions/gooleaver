Prerequisites to set azure as backend for terraform:
- resource group
- storage account
- storage container

To set them up, run `./init.sh` before anything else.

This will create all those resources and save Access Key in your env var. Additionally it will create a `backend.conf` file which will be used by `terraform init` to configure the backend. 

The access key is required for azure backend to save the terraform state in cloud.

Once the script has finished sucessfully, run terraform init like so:
```
terraform init -backend-config="backend.conf"
```

Additional info

Storage account name is global. For this reason a random number must be appended.

# Pushing and Pulling Images 
## login to azure container registry
``` 
az acr login -n acrGooleaver
```
## Pull from container registry
```
docker pull acrgooleaver.azurecr.io/hello-world
```
