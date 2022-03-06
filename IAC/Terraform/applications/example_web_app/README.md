Run the following commands under the directory 'Terraform/application/example_web_app'

Create and switch to a new workspace, e.g. prod
```
terraform workspace new prod
```

List all workspaces to confirm your current workspace
```
terraform workspace list
```

Change all variables in the prod.tfvars and then run
```
terraform apply -var-file='prod.tfvars' --auto-approve
```

Once completed, you can find the terraform state file in your APP_NAME-terraform-state bucket, specifically under the directory 'APP_NAME/Env_Name/'

![image](https://user-images.githubusercontent.com/80022917/156918425-064a5860-b491-4d93-8659-73366678cc3e.png)

Destroy all resources
```
terraform destroy -var-file='prod.tfvars' --auto-approve
```
