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

```
terraform apply -var-file='example.tfvars' --auto-approve
```



list your current workspace
```
terraform workspace list
```

create and switch to a new workspace, eg prod
```
terraform workspace new prod
```

