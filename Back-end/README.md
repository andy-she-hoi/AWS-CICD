# AWS-Backend-CICD

_BitBucket + CodePipeline + ECR + ECS Fargate + Application Load Balancer_

<b>All regions in this tutorial are ap-southeast-2</b>

# Step 1: Create a new ECR repo

![image](https://user-images.githubusercontent.com/80022917/148492430-3c903c04-9fb6-4776-9cf2-3906872f5ff6.png)

Click the button to copy your ECR repo URI
![image](https://user-images.githubusercontent.com/80022917/148492578-8914d406-8a71-4eae-b7c7-0591ebe600b9.png)

# Step 2: Prepare Dockerfile and buildspec.yml

## Dockerfile 

Please note that the node version and ENV may change

Please ask the developer for the container port which will be used in the EXPOSE clause

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

Put these 2 files in the root directory of your Bitbucket repo

# References:

1) https://aws.amazon.com/cn/blogs/devops/build-a-continuous-delivery-pipeline-for-your-container-images-with-amazon-ecr-as-source/
