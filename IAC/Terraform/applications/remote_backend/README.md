Download the code, and then open your terminal and run the following commands under the directory 'Terraform/application/remote_backend'

```
terraform init
```

Change the value of the app_name in the example.tfvars
```
terraform apply -var-file='example.tfvars' --auto-approve
```
