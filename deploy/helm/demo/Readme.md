# Config maps 

ConfigMap is an API object used to store non-confidential data in key-value pairs. Pods can consume ConfigMaps as environment variables, command-line arguments, or as configuration files in a volume.

Config maps can be created using kubectl create command.

``` kubectl create configmap <map-name> <data-source> ```


The data source can be a literal , or a file or a mixture of multiple files and literals 


for example 

``` kubectl create configmap example --from-file /src/main/resources/application.properties ``` 

This command creates a configmap which contains the key-value pairs of the settings present in application.properties file 

The command can be extended to include input from multiple files 

``` kubectl create configmap example2 --from-file <path_to_first_file> --from-file <path_to_second_file> ```


These configmaps are stored in the Kubernetes cluster and can be accessed by the Kubernetes Dashboard or by using 

``` kubectl get configmaps ```


## Secrets

Kubernetes [Secrets](https://kubernetes.io/docs/concepts/configuration/secret/) let you store and manage sensitive information, such as passwords, OAuth tokens, and ssh keys. Storing confidential information in a Secret is safer and more flexible than putting it verbatim in a Pod definition or in a container image.

A Secret is an object that contains a small amount of sensitive data such as a password, a token, or a key. Such information might otherwise be put in a Pod specification or in an image. Users can create Secrets and the system also creates some Secrets.


Secrets can be created in the same way using kubectl create secret command, or they can be created from yaml files. More information about kuberenetes secrets can be found in the documentation 

To check if a secret is sucessfully created or not we can use 

``` kubectl get secrets ``` 

Your output should be similar to this 

``` 
NAME                                      TYPE                                  DATA   AGE
agrippa-staleness-scheduler-tls-private   kubernetes.io/tls                     3      25d
bosun-guestbook-demo-tls-private          kubernetes.io/tls                     3      26d
bv-pypi-tls-private                       kubernetes.io/tls                     3      38d
bv-pypi-token-tg5x5                       kubernetes.io/service-account-token   3      38d
db-user-pass                              Opaque                                2      3d22h
default-token-4c4d7                       kubernetes.io/service-account-token   3      570d
demo-springboot-agrippa-tls-private       kubernetes.io/tls                     3      3d4h
demo-tls-private                          kubernetes.io/tls                     3      6d2h
istio.default                             istio.io/key-and-cert                 3      570d 

```





## Using Configmaps and Secrets in a Pod 

Configmaps can be used inside pods by using [VolumeMounts](https://kubernetes.io/docs/concepts/storage/volumes/) or Environment Variables 

### Config maps and Secrets using volumes 

Volumes can be can be added in the values.yaml file as shown below 

``` yaml
volumeMounts:
    - name: tmp
      mountPath: /tmp
    - name: config-volume
      mountPath: /etc/config
    - name: config-secret 
      mountPath: /etc/secret
    volumes:
      - name: tmp
        emptyDir: {}
      - name: config-volume
        configMap:
          name: example
      - name: config-secret
        secret:
          secretName: db-user-pass 
```

### Configmaps as environment variables 

``` yaml 
env:
      - name: SPECIAL_KEY
        valueFrom:
          configMapKeyRef:
            name: special-config
            key: special.how

```
Here SPECIAL_KEY is the name of the environment variable, that can be chosen as anything. The name field inside configMapKeyRef has to be name of the config map you have in your cluster. The key is a specific key stored in that configMap 
