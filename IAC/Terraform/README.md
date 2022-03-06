# Terrafrom

# Step 1: Create Hosted Zone in Route 53

![image](https://user-images.githubusercontent.com/80022917/156779538-0687011a-6d9a-47d3-ade5-9fcc9ecf82dd.png)

Please confirm all nameservers in Hosted Zone and Registered Domain are identical

![image](https://user-images.githubusercontent.com/80022917/156780481-4d7c1c9a-c6df-464a-94fa-f09d390d4227.png)
![image](https://user-images.githubusercontent.com/80022917/156780592-a594b3de-2731-45c8-8376-f92007cb30a9.png)

# Step 2: Install Terraform and AWS CLI

Terraform : https://learn.hashicorp.com/tutorials/terraform/install-cli

AWS CLI : https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html

# Step 3: Create a remote backend for Terraform

Download the code, and then open your terminal and run the following commands under the directory 'Terraform/application/remote_backend'

```
terraform init
```

Change the value of the app_name in the example.tfvars and then run:
```
terraform apply -var-file='example.tfvars' --auto-approve
```

# Step 4: Create AWS resources for Production environment

Run the following commands under the directory 'Terraform/application/example_web_app'

Create and switch to a new workspace, e.g. prod
```
terraform workspace new prod
```

List all workspaces to confirm your current workspace
```
terraform workspace list
```

Change all variables in the backend.tf and prod.tfvars and then run:
```
terraform init

terraform apply -var-file='prod.tfvars' --auto-approve
```
Once completed, you can find the terraform state file in your APP_NAME-terraform-state bucket, specifically under the directory 'APP_NAME/Env_Name/'

![image](https://user-images.githubusercontent.com/80022917/156918425-064a5860-b491-4d93-8659-73366678cc3e.png)

Destroy all resources
```
terraform destroy -var-file='prod.tfvars' --auto-approve
```

Under the directory 'Terraform/application/remote_backend', destroy the remote backend
```
terraform workspace select prod

terraform destroy -var-file='example.tfvars' --auto-approve
```

## Confirm you have DELETED all resources on console, especially NAT, ECS, and Elastic IP

# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs
