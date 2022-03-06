Run the following commands under the directory 'Terraform/application/example_web_app'

Create and switch to a new workspace, e.g. prod
```
terraform workspace new prod
```

List all workspaces to confirm your current workspace
```
terraform workspace list
```

Change all variables in the prod.tfvars and then run:
```
terraform apply -var-file='prod.tfvars' --auto-approve
```
