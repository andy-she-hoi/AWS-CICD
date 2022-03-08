# Terrafrom Cloud


# Step 1: Create Hosted Zone in Route 53

![image](https://user-images.githubusercontent.com/80022917/156779538-0687011a-6d9a-47d3-ade5-9fcc9ecf82dd.png)

Please confirm all nameservers in Hosted Zone and Registered Domain are identical

![image](https://user-images.githubusercontent.com/80022917/156780481-4d7c1c9a-c6df-464a-94fa-f09d390d4227.png)
![image](https://user-images.githubusercontent.com/80022917/156780592-a594b3de-2731-45c8-8376-f92007cb30a9.png)

# Step 2: Create your Terraform Cloud account

https://app.terraform.io/app/

# Step 3: Create a workspace on Terraform Cloud

![image](https://user-images.githubusercontent.com/80022917/157151179-fe889a0a-ea6c-4cd0-baf5-9e13da60f637.png)

In this example, the code will be stored in GitHub
![image](https://user-images.githubusercontent.com/80022917/157151278-c0f0548e-691f-4fc4-b8aa-49b5cdfcfefd.png)
![image](https://user-images.githubusercontent.com/80022917/157151644-a9f4f2d5-1d90-44c4-9e68-06056eb23612.png)
![image](https://user-images.githubusercontent.com/80022917/157152426-b8638cfc-575b-45f7-beb1-76f118729f57.png)
![image](https://user-images.githubusercontent.com/80022917/157152542-a95d4a6f-0ca9-4ad7-a9d5-d551a3751083.png)

Please update the Terraform Working Directory and VCS branch

Terraform Working Directory: IAC/Terraform/applications/example_web_app/

VCS branch: terraform_cloud

# Step 4: Add your AWS credential to your workspace as ENV variables

![image](https://user-images.githubusercontent.com/80022917/157154916-5b78941d-33fc-4505-9bde-d5382ed1ac92.png)
![image](https://user-images.githubusercontent.com/80022917/157154729-1421e50b-a2b1-4c97-9e47-126512809275.png)

# Step 5: Update the prod.auto.tfvars file

Update variables, especially _domain，subdomain and alb_domain_
![image](https://user-images.githubusercontent.com/80022917/157154146-b00a4461-2767-479c-8cbf-dd011588709b.png)

# Step 6: Create AWS resources for Production environment

![image](https://user-images.githubusercontent.com/80022917/157150112-54b7c1e2-48a4-4c85-81e7-91cb7a2bcf9a.png)

You can find the terraform.tfstate file here
![image](https://user-images.githubusercontent.com/80022917/157150607-98e9c845-12ff-4c65-aff5-8feec4d085bf.png)

If you would like to use the AWS CodePipeline to deploy, please follow the instruction in the README.md 

Frontend: https://github.com/andy-she-hoi/AWS-CICD/tree/main/Front-end

Backend: https://github.com/andy-she-hoi/AWS-CICD/tree/main/Back-end

_Remember to update the buildspec.yml (REPOSITORY_URI and ECS_Container_Name)_

# Step 5: Clean up



## Confirm you have DELETED all resources on console, especially NAT, ECS, and Elastic IP

# Reference: 
https://registry.terraform.io/providers/hashicorp/aws/latest/docs
