# AWS-Frontend-CICD

# Step 1: Register domain in Route 53

![image](https://user-images.githubusercontent.com/80022917/146707736-39c1be7b-129e-4523-9a9c-f919eb568390.png)

_For example: example.link_

![image](https://user-images.githubusercontent.com/80022917/146707975-6e8d81df-5d2a-4141-9cdb-47ba870d6136.png)

Fill in details and register the domain

# Step 2: Create S3 buckets

a) Please ensure names of S3 buckets are exactly the same with your domain (example.link) and subdomain (www.example.link)

b) Select a region for your app

c) Remain the rest and create the bucket

# Step 3: Change properties and permissions of S3 buckets

For the domain bucket (example.link):

Under the properties page, find the section Static website hosting and click Edit

![alt text](https://github.com/andy-she-hoi/AWS-Frontend-CICD/blob/main/Image/s3_properties_1.jpg?raw=true)

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

For the subdomain bucket (www.example.link):

Under the properties page, find the section Static website hosting and click Edit

![alt text](https://github.com/andy-she-hoi/AWS-Frontend-CICD/blob/main/Image/s3_properties_2.jpg?raw=true)

Please note that we do not need to edit Block public access (bucket settings) if we use Cloudfront

# Step 4: Create a CodePipeline

![alt text](https://github.com/andy-she-hoi/AWS-Frontend-CICD/blob/main/Image/codepipeline_1.jpg?raw=true)

<b>If you do not own the Bitbucket repo, please create a User role in IAM for the repo owner, and ask the owner generate a connection</b>

_You can delete the user after the connection is generated._
 
<b>If you own the Bitbucket repo, click Connect to Bitbucket and then generate a connection</b>
![alt text](https://github.com/andy-she-hoi/AWS-Frontend-CICD/blob/main/Image/codepipeline_2.jpg?raw=true)

Click the Create Project if needed

![alt text](https://github.com/andy-she-hoi/AWS-Frontend-CICD/blob/main/Image/codepipeline_3.jpg?raw=true)

_The UI will change after you tick the box (Extract file before deploy)_

![alt text](https://github.com/andy-she-hoi/AWS-Frontend-CICD/blob/main/Image/codepipeline_4.jpg?raw=true)

Review and create the pipeline

# Step 5: Create a Hosted Zone

Create a Hosted zone that the name of the hosted zone matches your domain name.

Click into the Hosted zone just created and choose Create record.

Choose Switch to wizard.

Choose Simple routing, and choose Next.

Choose Define simple record.

In Record name, accept the default value, which is the name of your hosted zone and your domain.

In Value/Route traffic to, choose Alias to S3 website endpoint.

Choose the Region.

Choose the S3 bucket.

The bucket name should match the name that appears in the Name box. In the Choose S3 bucket list, the bucket name appears with the Amazon S3 website endpoint for the Region where the bucket was created

_for example, s3-website-ap-southeast-2.amazonaws.com (example.link)_

Choose S3 bucket lists a bucket if:

You configured the bucket as a static website.

The bucket name is the same as the name of the record that you're creating.

The current AWS account created the bucket.

In Record type, choose A ‐ Routes traffic to an IPv4 address and some AWS resources.

For Evaluate target health, choose No.

Choose Define simple record.

To add an alias record for your subdomain (www.example.com)

Under Configure records, choose Define simple record.

In Record name for your subdomain, type www.

In Value/Route traffic to, choose Alias to S3 website endpoint.

Choose the Region.

Choose the S3 bucket, _for example, s3-website-ap-southeast-2.amazonaws.com (example.link)_

In Record type, choose A ‐ Routes traffic to an IPv4 address and some AWS resources.

For Evaluate target health, choose No.

Choose Define simple record.

On the Configure records page, choose Create records.

# Step 6: Create a distribution in CloudFront


# References:

1) https://docs.aws.amazon.com/AmazonS3/latest/userguide/website-hosting-custom-domain-walkthrough.html#website-hosting-custom-domain-walkthrough-domain-registry
2) https://docs.aws.amazon.com/codebuild/latest/userguide/available-runtimes.html
3) 
