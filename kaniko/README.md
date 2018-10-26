# Build a container image from source using Kaniko and push it to IBM Cloud Container Registry
Learn how to build a source into a container image from a Dockerfile inside a kubernetes cluster and push the image to IBM Cloud Container registry; all of this using Google's Kaniko tool.

**NOTE:** If you don't have a Kubernetes cluster with Knative and Istio installed, Refer [Prerequisites](https://github.com/VidyasagarMSC/knative-deploy#prerequisites) and [Setup IBMCloud CLI + Create a Cluster](https://github.com/VidyasagarMSC/knative-deploy#setup-ibmcloud-cli).

Clone the repo and move to `kaniko` folder
```
 $ git clone https://github.com/VidyasagarMSC/knative-deploy
 $ cd knative-deploy/kaniko
```
Replace `<region>` and/or `<namespace>` values in the `yaml` files with the appropriate values.

**Note**: To check your region, run `ibmcloud cr region` and to setup a new namespace, refer [this link](https://console.bluemix.net/docs/services/Registry/index.html#registry_namespace_add)

Execute the shell script by running the below command
```
$ ./deploy.sh
```
The build should have been kicked off. Let's take a look.
Running `kubectl get pods` , you should see a pod named `kaniko-build` with a postfix(say XXXXX).

For logs,
```
 $ kubectl logs kanika-build-XXXXX -c build-step-build-and-push
```

Execute the service
```
 $ kubectl apply --filename service.yaml
```
To find the IP address for your service, use `kubectl get svc knative-ingressgateway -n istio-system` to get the ingress IP for your cluster. If your cluster is new, it may take sometime for the service to get assigned an external IP address.
```
$ export IP_ADDRESS=$(kubectl get svc knative-ingressgateway --namespace istio-system --output 'jsonpath={.status.loadBalancer.ingress[0].ip}')
```
To find the URL for your service, use `kubectl get services.serving.knative.dev knative-node-app --output jsonpath='{.status.domain}'`
```
$ export HOST_URL=$(kubectl get services.serving.knative.dev knative-node-kaniko  --output jsonpath='{.status.domain}')
```
Now you can make a request to your app to see the result.
```
$ curl -H "Host: ${HOST_URL}" http://${IP_ADDRESS}

Response: Kaniko Node App running on IBM Cloud
```
### Clean Up
Run the below command to remove the sample app from your cluster
```
$ kubectl delete --filename service.yaml
```
To delete other Kaniko BuildTemplate,Secret,ServiceAccount and Build,execute the below script
```
$ ./delete.sh
```
To delete the cluster (removes everything), enter the following command:
```
$ ibmcloud cs cluster-rm $CLUSTER_NAME
```
### Related Content
- [Install Knative](https://medium.com/vmacwrites/install-knative-with-istio-on-iks-cluster-and-deploy-an-app-on-ibm-cloud-7b7d368b9833) with Istio and deploy an app on IBM Cloud
- [Build a container image inside a K8s cluster](https://medium.com/@VidyasagarMSC/build-a-container-image-inside-a-k8s-cluster-and-push-it-to-ibm-cloud-container-registry-abac9b1e5246) and push it to IBM Cloud Container Registry
- Knative [Monitoring](https://medium.com/vmacwrites/knative-monitoring-with-grafana-zipkin-weavescope-other-plugins-30a2d8d20344)