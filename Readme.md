# Host an image to a Kuberenetes Cluster using bosun

To initiate the process we need to push the image to an AWS ECR repository. We can create a Private repository using the AWS dashboard 

To push an image to the registry manually follow the following steps 

1. $ aws ecr get-login-password --region us-east-1 --profile qa| docker login --username AWS --password-stdin 549050352176.dkr.ecr.us-east-1.amazonaws.com

2. Do a Docker build on your image and tag it as necessary . 
 ``` $ docker build -t <image_tag> ```

3. docker tag agrippa-staleness-check-scheduler:latest 549050352176.dkr.ecr.us-east-1.amazonaws.com/agrippa-staleness-check-scheduler:1.0.0

4.  docker push 549050352176.dkr.ecr.us-east-1.amazonaws.com/agrippa-staleness-check-scheduler:1.0.0

![alt text](https://github.com/rrsrahul/rrsrahul/Demo/images/master/image1.png?raw=true)


