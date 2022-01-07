# AWS-Backend-CICD

_BitBucket + CodePipeline + ECR + ECS Fargate + Application Load Balancer_

<b>All regions in this tutorial are ap-southeast-2</b>

# Step 1: Prepare Dcokerfile and buildspec.yml

## Dcokerfile 

Please note that the node version may change

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

Please change the REPOSITORY_URI

```
version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws --version
      - aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin YOUR_AWS_ID.dkr.ecr.ap-southeast-2.amazonaws.com
      - REPOSITORY_URI=YOUR_AWS_ID.dkr.ecr.ap-southeast-2.amazonaws.com/YOUR_ECR_REPO
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

Put these 2 files in your Bitbucket repo.

# References:

1) https://aws.amazon.com/cn/blogs/devops/build-a-continuous-delivery-pipeline-for-your-container-images-with-amazon-ecr-as-source/
