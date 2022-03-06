Download the code, and then open your terminal and run the following commands under the directory 'Terraform/application/remote_backend'

```
terraform init
```

Change the value of the app_name in the example.tfvars and then run:
```
terraform apply -var-file='example.tfvars' --auto-approve
```

Destroy all resources
```
terraform destroy -var-file='example.tfvars' --auto-approve
```
