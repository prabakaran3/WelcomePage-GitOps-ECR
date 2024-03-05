# Mapup_Assesment

#NODE HELLO WORLD

Simple node.js app that servers "hello world"

#DOCKERFILE

we have updated the dockerfile in the repository to the run this nodejs application in the docker container

#ECR

Create an Private repository in the AWS to store the build image of our application.
Once Created Repository u will get the ECR link in the comsole.

    ECR Link =  349734401792.dkr.ecr.ap-south-1.amazonaws.com/hello_world

Before pushing  build image into the repository we need to authenication,To authenicate AWS ECR repository.

Install aws cli and configure. Once configured run the below cli command to authenicate to access the ECR repository.

    docker login -u AWS -p $(aws ecr get-login-password --region ap-south-1)  349734401792.dkr.ecr.ap-south-1.amazonaws.com/hello_world

# Steps to Build image, Push image into the ECR  and Run docker with updated image.

    docker build -t hello_world:latest .  -->  To build the application

    docker tage hello_world:latest 349734401792.dkr.ecr.ap-south-1.amazonaws.com/hello_world:hello-world

    docker push 349734401792.dkr.ecr.ap-south-1.amazonaws.com/hello_world:hello-world

#Run the application with updated Image

    docker run -d -p 3000:3000 349734401792.dkr.ecr.ap-south-1.amazonaws.com/hello_world:hello-world



