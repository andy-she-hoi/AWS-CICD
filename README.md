# AWS-Frontend-CICD

# Step 1: Create S3 buckets

a) Please ensure names of S3 buckets are exactly the same with your domain and subdomain
   For example: example.link and www.example.link

b) Select a region for your app

c) Remain the rest and create the bucket

# Step 2: Change properties and permissions of S3 buckets

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

# Step 3: Create a CodePipeline

Step 1
![alt text](https://github.com/andy-she-hoi/AWS-Frontend-CICD/blob/main/Image/codepipeline_1.jpg?raw=true)

Step 2

<b>If you do not own the Bitbucket repo, please create a User role in IAM for the repo owner, and ask the owner generate a connection</b>

_You can delete the user after the connection is generated._
 
<b>If you own the Bitbucket repo, click Connect to Bitbucket and then generate a connection</b>
![alt text](https://github.com/andy-she-hoi/AWS-Frontend-CICD/blob/main/Image/codepipeline_2.jpg?raw=true)

Step 3

Click the Create Project if needed

![alt text](https://github.com/andy-she-hoi/AWS-Frontend-CICD/blob/main/Image/codepipeline_3.jpg?raw=true)

Step 4

_The UI will change after you tick the box_

![alt text](https://github.com/andy-she-hoi/AWS-Frontend-CICD/blob/main/Image/codepipeline_4.jpg?raw=true)

Step 5

Review and create the pipeline

References:
1) https://docs.aws.amazon.com/AmazonS3/latest/userguide/website-hosting-custom-domain-walkthrough.html#website-hosting-custom-domain-walkthrough-domain-registry
2) https://docs.aws.amazon.com/codebuild/latest/userguide/available-runtimes.html
3) 
