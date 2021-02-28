# Host an image to a Kuberenetes Cluster using bosun

## Installing Bosun on local machine 

```brew tap bazaarvoice/bazaarvoice git@github.com:bazaarvoice/homebrew-bazaarvoice.git```
```brew install bosuncfg```

Once the installatio is complete. Execute this command to set up the Kubernetes Cluster Configuration 

```  export KUBECONFIG="/usr/local/etc/bosun/kubeconfig.yaml"  ```

The kubens command is used for listing all the namespaces in the cluster and the kubectx command is used for listing all the clusters

``` kubens <your_namespace> ```

This command will connect you to your respective namespace and you can use all the kubernetes api for listing and deploying 

To initiate the process we need to push the image to an AWS ECR repository. We can create a Private repository using the AWS dashboard 


Follow the View Push commands as shown in this image   
![alt text](https://github.com/rrsrahul/Demo/blob/master/images/image1.png)

To push an image to the registry manually follow the following steps 

1. $ aws ecr get-login-password --region us-east-1 --profile qa| docker login --username AWS --password-stdin 549050352176.dkr.ecr.us-east-1.amazonaws.com

2. Do a Docker build on your image and tag it as necessary. \                   
 ``` $ docker build -t <image_tag> ```

3. ```docker tag agrippa-staleness-check-scheduler:latest 549050352176.dkr.ecr.us-east-1.amazonaws.com/agrippa-staleness-check-scheduler:1.0.0```

4.  ```docker push 549050352176.dkr.ecr.us-east-1.amazonaws.com/agrippa-staleness-check-scheduler:1.0.0```


Simplest way to create config is using [bosun-init-repo](https://github.com/bazaarvoice/bosun-repo-init). 

``` bosun-repo-init --repo-dir . --github-token ${GITHUB_TOKEN} --namespace <team_namespace> --team-email <team_email>@bazaarvoice.com ```

Replace your namespace and email ID. A Github token can be created following [this](https://github.com/settings/tokens)

The Init of the folder of your project creates a deploy folder which contains 3 files such as 
* values.yaml 
* values-qa.yaml
* values-prod.yaml

The Settings for deployment of an image to your cluster can be changed using these files. 
The values.yaml file contains an URI for the image to be deployed. The necessary ECR  image should be passed here.

![alt text](https://github.com/rrsrahul/Demo/blob/master/images/carbon.png)

After Making the necessary changes in the yaml files. We can deploy using 

``` make deploy-qa ```

This command uses helm to deploy like this 

```  helm upgrade --install -n agrippa demo ./deploy/helm/demo/ -f ./deploy/helm/demo/values.yaml -f ./deploy/helm/demo/values-qa.yaml ```

To check the health, status of a deployment we can use 

``` kubectl get pods ``` or alternatively check the kubernetes [dashboard](https://dashboard.eu-west-1a.bosun.qa.bazaarvoice.com/#/pod/agrippa/demo-59df4b6449-4gssn?namespace=agrippa). To login into the dashboard we need to create a token which can be done by using the following command 

``` aws-iam-authenticator token -i eu-west-1a.bosun.qa.bazaarvoice.com ```


The endpoint for the deployed pod can be accessed by using 

``` ```

The deployment can fail due to many reasons. The main few are due to the container failing the health and readiness checks. This can be changed by updating the health checks in the values.yaml file 

![alt text](https://github.com/rrsrahul/Demo/blob/master/images/carbon6.png)

The deployment can also fail due to the lack of resources, the necessary resources can be updated in the values.yaml file 

![alt text](https://github.com/rrsrahul/Demo/blob/master/images/carbon7.png)




A Deployment can be deleted using 

``` helm -n agrippa delete agrippa-staleness-schedule ```






