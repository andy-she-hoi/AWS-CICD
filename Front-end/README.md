# AWS-Frontend-CICD

_BitBucket + CodePipeline + S3 + Route 53 + CloudFront_

<b>Except that the region of ACM is us-east-1, all regions in this tutorial are ap-southeast-2</b>

# Step 1: Register domain in Route 53

![image](https://user-images.githubusercontent.com/80022917/146707736-39c1be7b-129e-4523-9a9c-f919eb568390.png)

_For example: example.link_

![image](https://user-images.githubusercontent.com/80022917/146707975-6e8d81df-5d2a-4141-9cdb-47ba870d6136.png)

Fill in details and register the domain

# Step 2: Create S3 buckets

a) Please ensure names of S3 buckets are exactly the same with your domain (example.link) and subdomain (www.example.link)

b) Select a region for your app (ap-southeast-2 is using for this tutorial)

c) Enable the Bucket Versioning

d) Remain the rest and create the bucket

# Step 3: Change properties and permissions of S3 buckets

For the domain bucket (example.link):

Under the properties page, find the section Static website hosting and click Edit

![alt text](https://github.com/andy-she-hoi/AWS-CICD/blob/main/Image/s3_properties_1.jpg?raw=true)

Under the permissions page, find the section Cross-origin resource sharing (CORS) and click Edit

Attach CORS policy for the domain bucket
```
[
    {
        "AllowedHeaders": [],
        "AllowedMethods": [
            "GET"
        ],
        "AllowedOrigins": [
            "*"
        ],
        "ExposeHeaders": []
    }
]
```
AllowedMethods: please check with the developer

AllowedOrigins: the best practice should be "https://Your-Bucket-Name"

For the subdomain bucket (www.example.link):

Under the properties page, find the section Static website hosting and click Edit

![alt text](https://github.com/andy-she-hoi/AWS-CICD/blob/main/Image/s3_properties_2.jpg?raw=true)

Please note that we do not need to edit Block public access (bucket settings) if we use Cloudfront

# Step 4: Create the buildspec.yml

<b>Upload the buildspec.yml to the root directory of the master branch</b>

```
version: 0.2

phases:
  install:
    runtime-versions:
      nodejs: 14
      
  pre_build:
    commands:
      - echo Installing source NPM dependencies...
      - npm install
      
  build:
    commands:
      - echo Build started on `date`
      - echo Compiling the Node.js code
      - npm run build
      
  post_build:
    commands:
      - echo Build completed on `date`

# Include only the files required for your application to run.
artifacts:
  files:
    - '**/*'
  discard-paths: no
  base-directory: build
```

# Step 5: Create a CodePipeline

![alt text](https://github.com/andy-she-hoi/AWS-CICD/blob/main/Image/codepipeline_1.jpg?raw=true)

<b>If you do not own the Bitbucket repo, please create a User role in IAM for the repo owner, and ask the owner generate a connection</b>

_You can delete the user after the connection is generated._
 
<b>If you own the Bitbucket repo, click Connect to Bitbucket and then generate a connection</b>
![alt text](https://github.com/andy-she-hoi/AWS-CICD/blob/main/Image/codepipeline_2.jpg?raw=true)

Next page, choose the CodeBuild and then click the Create Project button if needed
![image](https://user-images.githubusercontent.com/80022917/146712523-71dd9740-dce4-4428-aa39-9914d714891a.png)
![image](https://user-images.githubusercontent.com/80022917/146712544-ecb758f5-69e2-4350-951d-3f45deedff58.png)

More details of images can be founded: https://docs.aws.amazon.com/codebuild/latest/userguide/available-runtimes.html

![alt text](https://github.com/andy-she-hoi/AWS-CICD/blob/main/Image/codepipeline_3.jpg?raw=true)

_The UI will change after you tick the box (Extract file before deploy)_

![alt text](https://github.com/andy-she-hoi/AWS-CICD/blob/main/Image/codepipeline_4.jpg?raw=true)

Review and create the pipeline

# Step 6: Create a Hosted Zone

![image](https://user-images.githubusercontent.com/80022917/154618248-269df183-f8dc-4be2-b2fc-ebd152d56ca8.png)

Click into the Hosted zone just created and choose Create record.

(Switch to wizard if you have a different UI) Choose Simple routing, and choose Next.

![image](https://user-images.githubusercontent.com/80022917/154618303-7affd25b-36f9-4d75-a672-ee7a0b3dda7e.png)

Choose Define simple record.

In Record name, accept the default value, which is the name of your hosted zone and your domain.

In Value/Route traffic to, choose Alias to S3 website endpoint.

Choose the Region and the S3 bucket.

For Evaluate target health, choose Yes.

![image](https://user-images.githubusercontent.com/80022917/154618448-9e4de57d-fcc8-4bf0-b5a8-7dda0a4494de.png)

To add an alias record for your subdomain (www.example.com)

![image](https://user-images.githubusercontent.com/80022917/154618654-55f12f05-2c07-4452-a55f-2fc568b72022.png)

On the Configure records page, choose Create records.

# Step 7: Request a certificate in AWS Certificate Manager
<b>Please ensure the region is us-east-1 before doing anything</b>

![image](https://user-images.githubusercontent.com/80022917/146711296-43b00f2c-0bb4-4329-9547-aa66be16f2b2.png)
![image](https://user-images.githubusercontent.com/80022917/150338056-239f72ff-5e59-431d-84b8-a931d4efdd03.png)

In Route 53, the ALB record (alb.example.link) will be used as the alias for the Application Load Balancer which is important for HTTPS requests

DNS Validation
![image](https://user-images.githubusercontent.com/80022917/150338736-d863d361-9a06-4760-8404-b456855140f9.png)

Please confirm all nameservers in Hosted Zone and Registered Domain are identical

![image](https://user-images.githubusercontent.com/80022917/154638469-8f85e48d-e368-4f66-9eb4-38fc19225f9a.png)
![image](https://user-images.githubusercontent.com/80022917/154638833-7d7b13e9-701f-4bab-9971-74004d76f5c4.png)

Your new certificate might continue to display a status of Pending validation for up to 30 minutes

After the verification is successful, you will see that the status of your certificate becomes Issued, and there are 3 more records in the Hosted Zone of Route 53.

# Step 8: Create a distribution in CloudFront

![alt text](https://github.com/andy-she-hoi/AWS-CICD/blob/main/Image/cloudfront_1.jpg?raw=true)
![alt text](https://github.com/andy-she-hoi/AWS-CICD/blob/main/Image/cloudfront_2.jpg?raw=true)
![alt text](https://github.com/andy-she-hoi/AWS-CICD/blob/main/Image/cloudfront_3.jpg?raw=true)
![alt text](https://github.com/andy-she-hoi/AWS-CICD/blob/main/Image/cloudfront_4.jpg?raw=true)
![alt text](https://github.com/andy-she-hoi/AWS-CICD/blob/main/Image/cloudfront_5.jpg?raw=true)

# Step 9: Update records in Route 53

Under Records, select the type A record of your domain and subdomain.

Domain: example.link

![alt text](https://github.com/andy-she-hoi/AWS-CICD/blob/main/Image/hosted_zone_1.jpg?raw=true)

Subdomain: www.example.link

![alt text](https://github.com/andy-she-hoi/AWS-CICD/blob/main/Image/hosted_zone_2.jpg?raw=true)

# Step 10: Update the S3 bucket policy

<b>Replace YOUR_DOMAIN_BUCKET and YOUR_OAI</b>

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "1",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity YOUR_OAI"
            },
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::YOUR_DOMAIN_BUCKET/*"
        },
        {
            "Sid": "2",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity YOUR_OAI"
            },
            "Action": "s3:ListBucket",
            "Resource": "arn:aws:s3:::YOUR_DOMAIN_BUCKET"
        }
    ]
}
```

# References:

1) https://docs.aws.amazon.com/AmazonS3/latest/userguide/website-hosting-custom-domain-walkthrough.html#website-hosting-custom-domain-walkthrough-domain-registry
2) https://docs.aws.amazon.com/acm/latest/userguide/dns-validation.html
3) https://docs.aws.amazon.com/AmazonS3/latest/userguide/website-hosting-cloudfront-walkthrough.html
