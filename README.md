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

# Step 3: Attach CORS policy for the domain bucket


References:
1) https://docs.aws.amazon.com/AmazonS3/latest/userguide/website-hosting-custom-domain-walkthrough.html#website-hosting-custom-domain-walkthrough-domain-registry
2) https://docs.aws.amazon.com/codebuild/latest/userguide/available-runtimes.html
3) 
