In this example, I have explained how to dockerize an nodejs application, Push an latest image to AWS ECR repository via GitOps and we run the application with the latest Image.

# Sample Welcome Page

In this repository we have simple node.js app that servers "WelcomePage"

# DOCKERFILE

we have updated dockerfile in the repository to the run the nodejs application in the docker container

# AWS ECR

Create an Public or Private repository(Note:- In this example,I have created public repository.It is open to pull images from Repository) in the AWS to store the build image of our application.
Once Created ECR repository u will get the ECR repository link in the comsole.

    ECR Link =  public.ecr.aws/b3n7j6v1/hello

Before pushing build image into the repository need authenication to access the repository.
To authenicate AWS ECR repository, Install aws cli and configure with Access key and secret key.Once configured run the below cli command to authenicate to access the ECR repository.

(Note:- In Github actions workflow, I have configured aws credentials in Github secrets to push the update image to the repository.)

    aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws/b3n7j6v1

# Steps to Build,Tag,and Push image into the ECR and Run docker with updated image.

    docker build -t hello:latest .  -->  To build the application

    docker tag hello:latest public.ecr.aws/b3n7j6v1:hello

    docker push public.ecr.aws/b3n7j6v1:hello

# Run the application with updated Image

    docker run -d -p 3000:3000 public.ecr.aws/b3n7j6v1/hello:hello

# The above detailed steps are pipelined via GitOps
we have added this workflow in the repository, Once we commit the changes in the main branch actions will trigger the workflow and latest images will pushed to the ECR Repository.
After that, Run the application with updated image.

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

