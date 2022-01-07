# AWS-Backend-CICD

_BitBucket + CodePipeline + ECR + ECS Fargate + Application Load Balancer_

<b>All regions in this tutorial are ap-southeast-2</b>

# Step 1: Create a new ECR Repo

![image](https://user-images.githubusercontent.com/80022917/148492430-3c903c04-9fb6-4776-9cf2-3906872f5ff6.png)

Click the button to copy your ECR Repo URI
![image](https://user-images.githubusercontent.com/80022917/148492578-8914d406-8a71-4eae-b7c7-0591ebe600b9.png)

# Step 2: Prepare Dockerfile and buildspec.yml

## Dockerfile 

Please note that the node version and ENV may change

Please ask the developer for the container port which will be used in the EXPOSE clause

In this example, port 8081 will be used for containers

```
FROM node:16-alpine as build

WORKDIR /apis

ENV PATH /apis/node_modules/.bin:$PATH

COPY ./package.json ./
COPY ./package-lock.json ./

RUN npm install --quiet

COPY . ./

EXPOSE 8081

CMD npm start
```

## buildspec.yml

Please modify the CHANGE HERE in the below template with the URI you copied at step 1

For example: 

CHANGE_HERE_1 = YOUR_AWS_ID.dkr.ecr.ap-southeast-2.amazonaws.com

CHANGE_HERE_2 (ECR Repo URI) = YOUR_AWS_ID.dkr.ecr.ap-southeast-2.amazonaws.com/example

```
version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws --version
      - aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin CHANGE_HERE_1
      - REPOSITORY_URI=CHANGE_HERE_2
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)

  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - docker build -t $REPOSITORY_URI:$COMMIT_HASH .
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker images...
      - docker push $REPOSITORY_URI:$COMMIT_HASH
      - echo Writing image definitions file...
      - printf '[{"name":"skipq-app","imageUri":"%s"}]' $REPOSITORY_URI:$COMMIT_HASH > imagedefinitions.json
artifacts:
    files: imagedefinitions.json
```

Upload these 2 files into the root directory of your Bitbucket repo

# Step 3: Create Cluster, Task Definition and Service for ECS Fargate

## Cluster
![image](https://user-images.githubusercontent.com/80022917/148495158-80aa45ef-9799-468c-bec9-dabf1feef819.png)

## Task Definition
![image](https://user-images.githubusercontent.com/80022917/148493878-88d0050a-8ddd-4fac-8558-737fdc3c81cc.png)
![image](https://user-images.githubusercontent.com/80022917/148494271-e430f2bb-d751-4e57-a2ed-ed0055a9c30c.png)
![image](https://user-images.githubusercontent.com/80022917/148494380-43e27587-c065-425b-8abf-8bebf89d2124.png)

Click the button to add container

![image](https://user-images.githubusercontent.com/80022917/148494687-deceba8f-5a0e-4e39-b445-b82faad4b222.png)
![image](https://user-images.githubusercontent.com/80022917/148494891-a19b1b64-612d-4d6a-9bfe-a4b10eb1c696.png)

 Click the Create at the bottom
 
 ## Service


# References:

1) https://aws.amazon.com/cn/blogs/devops/build-a-continuous-delivery-pipeline-for-your-container-images-with-amazon-ecr-as-source/
