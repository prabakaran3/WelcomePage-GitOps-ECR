# Sample Welcome Page

# NODE HELLO WORLD

Simple node.js app that servers "hello world"

# DOCKERFILE

we have updated dockerfile in this repository to the run the nodejs application in the docker container

# ECR

Create an Public or Private repository(Note:- In this example,i have created public repository.It is open to pull images from Repository) in the AWS to store the build image of our application.
Once Created Repository u will get the ECR link in the comsole.

    ECR Link =  public.ecr.aws/b3n7j6v1/hello

Before pushing build image into the repository we need to authenication,To authenicate AWS ECR repository.
Install aws cli and configure.Once configured run the below cli command to authenicate to access the ECR repository.

In Github actions workflow, i have configured aws credentials in secrets to push the update image to the repository.

    aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/b3n7j6v1

# Steps to Build,Tag,and Push image into the ECR and Run docker with updated image.

    docker build -t hello:latest .  -->  To build the application

    docker tag hello:latest public.ecr.aws/b3n7j6v1:hello

    docker push public.ecr.aws/b3n7j6v1:hello

# Run the application with updated Image

    docker run -d -p 3000:3000 public.ecr.aws/b3n7j6v1/hello:hello

# The above steps are pipelined in the github action workflow
Workflow yaml file

    name: Build nodejs app and push image to AWS ECR
    on:
    # Trigger analysis when pushing in main or pull requests, and when creating 
      push:
        branches:
        - main
      pull_request:
        branches:
        - main

    jobs:
      build-and-push:
        runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Login to AWS ECR
        id: login-ecr
        run: |
          aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/b3n7j6v1
        env:
          TOKEN: ${{ secrets.TOKEN }}
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }} 

      - name: Build and push Docker image
        run: |
          docker build -t hello .
          docker tag hello:latest public.ecr.aws/b3n7j6v1/hello:hello
          docker push public.ecr.aws/b3n7j6v1/hello:hello

