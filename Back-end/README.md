# AWS-Backend-CICD

_BitBucket + CodePipeline + ECR + ECS Fargate + Application Load Balancer + NAT Gateway_

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

ARG DB_URL
ARG PROD_DB_URL
ARG JWT_SECRET
ARG AWS_REGION
ARG AWS_ACCESS_KEY
ARG AWS_SECRET_KEY
ARG AWS_S3_BUCKET
ENV PATH /apis/node_modules/.bin:$PATH
ENV DB_URL=${DB_URL}
ENV PROD_DB_URL=${PROD_DB_URL}
ENV JWT_SECRET=${JWT_SECRET}
ENV AWS_REGION=${AWS_REGION}
ENV AWS_ACCESS_KEY=${AWS_ACCESS_KEY}
ENV AWS_SECRET_KEY=${AWS_SECRET_KEY}
ENV AWS_S3_BUCKET=${AWS_S3_BUCKET}

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

You may also find YOUR_AWS_ID (Account ID) on the top right conner

![image](https://user-images.githubusercontent.com/80022917/148495685-9f5b21da-6fb6-424e-979f-9fa9a3a32b76.png)


Please provide a Task_Definition_Name for your ECS Task Definition and replace the string "Task_Definition_Name" in the code below

```  
version: 0.2

phases:
  pre_build:
    commands:
      - echo Logging to Amazon ECR
      - aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin CHANGE_HERE_1
      - REPOSITORY_URI=CHANGE_HERE_2
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
  build:
    commands:
      - echo Building the Docker image
      - docker build --build-arg DB_URL=${DB_URL} --build-arg PROD_DB_URL=${PROD_DB_URL} --build-arg JWT_SECRET=${JWT_SECRET} --build-arg AWS_REGION=${AWS_REGION} --build-arg AWS_ACCESS_KEY=${AWS_ACCESS_KEY} --build-arg AWS_SECRET_KEY=${AWS_SECRET_KEY} --build-arg AWS_S3_BUCKET=${AWS_S3_BUCKET} -t $REPOSITORY_URI:$COMMIT_HASH .
  post_build:
    commands:
      - echo Build completed
      - echo Pushing the Docker image
      - docker push $REPOSITORY_URI:$COMMIT_HASH
      - echo Writing image definition files
      - printf '[{"name":"Task_Definition_Name","imageUri":"%s"}]' $REPOSITORY_URI:$COMMIT_HASH > imagedefinitions.json
      - cat imagedefinitions.json
artifacts:
  files: 
    - imagedefinitions.json
```

Upload these 2 files into the root directory of your Bitbucket repo

# Step 3: VPC, Subnet, Internet Gateway, NAT Gateway, Route Table

## VPC
![image](https://user-images.githubusercontent.com/80022917/149264088-5667b849-2148-40f7-93ce-529e57873b98.png)

Remain default setting and click the create button

## Subnets (2 Public Subnets and 2 Private Subnets)
![image](https://user-images.githubusercontent.com/80022917/149264456-8882db8f-80f6-4f37-b08d-38ec52efa063.png)

Repeat the above step to create 3 more subnets

![image](https://user-images.githubusercontent.com/80022917/149265089-558b426b-c508-4344-a75f-4a97909d6a10.png)

## Internet Gateway
![image](https://user-images.githubusercontent.com/80022917/149297763-caa700cb-145b-4eb1-a18d-2f4ff2517260.png)
![image](https://user-images.githubusercontent.com/80022917/149297832-fce87739-4bb7-4804-a496-fbc98e83bae4.png)

## NAT Gateway
![image](https://user-images.githubusercontent.com/80022917/149273298-92c60d87-a845-4b8a-9113-11368bcca23c.png)

## Route Table (1 Public RT and 1 Private RT)
![image](https://user-images.githubusercontent.com/80022917/149266239-8d646061-3b26-4de9-8e48-c282d755d8d7.png)
![image](https://user-images.githubusercontent.com/80022917/149266424-19c0bb40-c6ea-44af-8d82-3ee4c4e6a212.png)
![image](https://user-images.githubusercontent.com/80022917/149267184-31a828ef-d467-4443-80e5-1d86cbf13c35.png)

All traffic go to the Internet Gateway

Create another route table for private subnets
![image](https://user-images.githubusercontent.com/80022917/149266853-02e1f763-677c-4738-bb36-4c3fd7537335.png)
![image](https://user-images.githubusercontent.com/80022917/149266988-fca53cc3-90e9-4ae8-b73a-1128973f7b5f.png)

Add the NAT Gateway to the Route
![image](https://user-images.githubusercontent.com/80022917/149273761-cf67c6b1-2be0-43cf-87e8-7c8bd8130d39.png)

# Step 4: Security Group, Target Group and Application Load Balancer

## Security Group
![image](https://user-images.githubusercontent.com/80022917/150323817-421ecf71-eb8e-46dd-8b44-3fb3ec7a1dd1.png)
![image](https://user-images.githubusercontent.com/80022917/150323873-48411bf0-e968-4737-98d1-b76def3ac7bf.png)
![image](https://user-images.githubusercontent.com/80022917/150323921-bd73c23e-6770-4699-af2a-122af9c129de.png)


## Target Group
![image](https://user-images.githubusercontent.com/80022917/149270723-06d30f9d-6816-4546-8155-9a9d0dcb94ba.png)
![image](https://user-images.githubusercontent.com/80022917/149270864-802fbd74-51ee-4e5f-8a44-fcf023f10d45.png)

## Application Load Balancer
![image](https://user-images.githubusercontent.com/80022917/149269508-c28c2ac7-1147-49d7-b13c-b49174e2cb55.png)
![image](https://user-images.githubusercontent.com/80022917/149271360-44190085-c2db-4309-b17d-e7e35a79825f.png)
![image](https://user-images.githubusercontent.com/80022917/149271313-8a29e2e2-283a-44d2-bc32-d992cb0d03fa.png)
![image](https://user-images.githubusercontent.com/80022917/150299551-f10ae779-b88b-49d1-92ae-26ef55536956.png)
![image](https://user-images.githubusercontent.com/80022917/150299736-0720088e-f1bc-4278-8852-dbd3a830b861.png)

Go to Route 53 and add a new Simple Routing record for the ALB (select YES for Evaluate Target Health)
![image](https://user-images.githubusercontent.com/80022917/150330614-7ccf258d-0806-461b-a7f6-877cf3a577af.png)




# Step 5: Cluster, Task Definition and Service for ECS Fargate

## Cluster
![image](https://user-images.githubusercontent.com/80022917/148495158-80aa45ef-9799-468c-bec9-dabf1feef819.png)
![image](https://user-images.githubusercontent.com/80022917/149267797-2beec2f1-ae69-4874-8f93-b0d495ca9440.png)

## Task Definition
![image](https://user-images.githubusercontent.com/80022917/148493878-88d0050a-8ddd-4fac-8558-737fdc3c81cc.png)

## Please make sure the task definition name is the same as in buildspec.yml
![image](https://user-images.githubusercontent.com/80022917/148494271-e430f2bb-d751-4e57-a2ed-ed0055a9c30c.png)
![image](https://user-images.githubusercontent.com/80022917/148494380-43e27587-c065-425b-8abf-8bebf89d2124.png)

Click the button to add container

In the final stage, we will create a Codepipeline which will update your Task Definition automatically based on the buildspec.yml

So you do not need to care about the image URI yet, you may use the ECR Repo URI to fill this box but the task will not run successfully
![image](https://user-images.githubusercontent.com/80022917/148494687-deceba8f-5a0e-4e39-b445-b82faad4b222.png)
## Please make sure the Port Mapping is the same as in Dockerfile

![image](https://user-images.githubusercontent.com/80022917/148494891-a19b1b64-612d-4d6a-9bfe-a4b10eb1c696.png)

 Click the Create at the bottom
 
 ## Service
![image](https://user-images.githubusercontent.com/80022917/149268774-b54dd730-dc4c-4dff-ae2d-77736e0c30b6.png)
![image](https://user-images.githubusercontent.com/80022917/149268849-ed950773-aa6e-4d2b-bc59-fb147c2def66.png)
![image](https://user-images.githubusercontent.com/80022917/149275432-ba8f8f1b-2ec7-461c-bc7e-d2e79b2622b5.png)
![image](https://user-images.githubusercontent.com/80022917/149275224-ad1529a4-6621-451f-808d-618057427ba1.png)
![image](https://user-images.githubusercontent.com/80022917/149275597-0c3752af-dc59-45bb-bd2f-aa470cb99ee9.png)
![image](https://user-images.githubusercontent.com/80022917/149275647-ba8e55a5-d58e-4ea2-b5f9-8de1097c589b.png)
![image](https://user-images.githubusercontent.com/80022917/149275723-cd38d9ce-2704-4bfe-a061-6725190161c9.png)
![image](https://user-images.githubusercontent.com/80022917/149275824-32543d83-897b-4789-b6f6-8fe078c32026.png)

Create the service and wait 

# Step 6: Create Codepipeline
![image](https://user-images.githubusercontent.com/80022917/149276477-0e1f7d95-75b0-4b1e-ae66-5f031463dcfb.png)
![image](https://user-images.githubusercontent.com/80022917/149278433-0c999689-c03e-4f1a-b21d-e4a0ea5f8b56.png)
![image](https://user-images.githubusercontent.com/80022917/149276715-01038b4e-66df-425b-ab55-0623c133e213.png)
![image](https://user-images.githubusercontent.com/80022917/149277033-c5d63ce3-e298-4f52-a666-c215602c42fa.png)
![image](https://user-images.githubusercontent.com/80022917/149277114-194b8ea2-b5cb-45fe-8d33-0f818bade6c9.png)
![image](https://user-images.githubusercontent.com/80022917/149277149-ad2da487-d59e-455c-9ea3-013598f328cd.png)
![image](https://user-images.githubusercontent.com/80022917/149277266-a5cfdfb3-cc5c-4c9b-862b-fd67fdce4551.png)

After you create the pipeline, it will not run successfully because the CodeBuild Role need one more permission

Attach the policy (AmazonEC2ContainerRegistryPowerUser) to your CodeBuild Role
![image](https://user-images.githubusercontent.com/80022917/149290125-d5a107d8-a809-45bf-ae62-8e362dbe34af.png)

## When Codepipeline is triggered automatically or manually retry, a new Task Definition will be generated, and the latest revision will be used when deploying to ECS. You need to ensure that the revision of the task definition used in the current task is the latest. If the revision of the currently running task is not the latest, you need to deregister the previous revision first, and then stop those tasks using the previous revision.

![image](https://user-images.githubusercontent.com/80022917/149333280-6411be94-a06c-474f-849e-4ef1a319b83f.png)
![image](https://user-images.githubusercontent.com/80022917/149333624-d1bbdb81-f8e5-461b-baae-ad9da17a30a5.png)

## CodePipeline Completed
![image](https://user-images.githubusercontent.com/80022917/149291602-26d6baee-9a91-47a8-80e4-c81e83708817.png)
![image](https://user-images.githubusercontent.com/80022917/149333947-83398a00-2101-442d-863c-764d35c348c5.png)


# Step 7: Check the Health Status
![image](https://user-images.githubusercontent.com/80022917/149292104-55046d7f-428c-4eca-bbe4-208c3ac9121b.png)
Copy the DNS name of your Application Load Balancer and run it in the browser
![image](https://user-images.githubusercontent.com/80022917/149328146-84dad1e4-97f3-4321-953a-d1e587f7e9cb.png)

Alternatively, you can use the ALB record in Route 53 to redirect to the DNS
![image](https://user-images.githubusercontent.com/80022917/150340985-44e9ebd2-16fe-4944-806d-0389cd81bc16.png)

## Please pass the ALB record to the Dev team so they can connect the Frontend and the Backend

## Please DO NOT Forget to DELETE all resource, especially NAT Gateway, ECS, and Elastic IP

# References:

1) https://aws.amazon.com/cn/blogs/devops/build-a-continuous-delivery-pipeline-for-your-container-images-with-amazon-ecr-as-source/
