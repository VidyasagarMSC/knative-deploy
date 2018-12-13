# Knative-deploy

Step-by-step instructions to install Knative with Istio 1.0.2 on IBM Cloud Kubernetes Service(IKS), build and push your image to IBM Cloud Container Registry and deploy the app.

> For up-to-date instructions, refer to this [article on Medium](https://medium.com/vmacwrites/install-knative-with-istio-on-iks-cluster-and-deploy-an-app-on-ibm-cloud-7b7d368b9833)

### Prerequisites

- [Node and npm](https://www.npmjs.com/get-npm)
- [Download and install the ibmcloud command line tool](https://console.bluemix.net/docs/cli/index.html#overview)

### Setup IBMCloud CLI

- Install the cs (container-service) and cr (container-registry) plugins

```
  ibmcloud plugin install container-service -r Bluemix
  ibmcloud plugin install container-registry -r Bluemix
```
- Authorize ibmcloud:

```
  ibmcloud login
```
- [Setup environment variables](https://github.com/knative/docs/blob/master/install/Knative-with-IKS.md#setting-environment-variables)
- [Create a Kubernetes Cluster](https://github.com/knative/docs/blob/master/install/Knative-with-IKS.md#creating-a-kubernetes-cluster)

- Knative depends on Istio.

```
  kubectl apply --filename https://raw.githubusercontent.com/knative/serving/master/third_party/istio-1.0.2/istio.yaml
```

- Label the default namespace with istio-injection=enabled:
 `kubectl label namespace default istio-injection=enabled`
- Monitor the Istio components until all of the components show a STATUS of Running or Completed:
`kubectl get pods --namespace istio-system`

- [Installing Knative components](https://github.com/knative/docs/blob/master/install/Knative-with-IKS.md#installing-knative-components)


### Build your source into a container image and push using Kaniko
To Build a source into a container image from a Dockerfile inside a kubernetes cluster and push the image to IBM Cloud Container registry; all of this using Google's Kaniko tool, refer [this link](https://github.com/VidyasagarMSC/knative-deploy/blob/master/kaniko/README.md)

OR

to build a container Image using Docker Daemon, follow the steps below

### Build the app as a container image using Docker Daemon
> Rehash of [helloworld-nodejs](https://github.com/knative/docs/tree/master/serving/samples/helloworld-nodejs)

- Clone the repo
```
  git clone https://github.com/VidyasagarMSC/knative-deploy.git
  cd knative-deploy
```
- Install dependencies
```
  npm install
```
- Build and Push the Docker image to IBM Cloud Container Registry by replacing `<region>` and `<namespace>` values

```
  ibmcloud cr build -t registry.<region>.bluemix.net/<namespace>/knative-node-app .
```
- Open `service.yaml`, replace `image` and run the below command
```
  kubectl apply --filename service.yaml
```

### Test your app

- To find the IP address for your service, use `kubectl get svc knative-ingressgateway -n istio-system` to get the ingress IP for your cluster. If your cluster is new, it may take sometime for the service to get asssigned an external IP address.

```
export IP_ADDRESS=$(kubectl get svc knative-ingressgateway --namespace istio-system --output 'jsonpath={.status.loadBalancer.ingress[0].ip}')
```

- To find the URL for your service, use `kubectl get services.serving.knative.dev knative-node-app  --output jsonpath='{.status.domain}'`
```
export HOST_URL=$(kubectl get services.serving.knative.dev knative-node-app  --output jsonpath='{.status.domain}')
```

- Now you can make a request to your app to see the result.
```
 curl -H "Host: ${HOST_URL}" http://${IP_ADDRESS}
Node App running on IBM Cloud
```

### Cleanup

- Run the below command to remove the sample app from your cluster

```
 kubectl delete --filename service.yaml
```

- To delete the cluster, enter the following command:
```
 ibmcloud cs cluster-rm $CLUSTER_NAME
```

### Related Content
- [Build a container image inside a K8s cluster](https://medium.com/@VidyasagarMSC/build-a-container-image-inside-a-k8s-cluster-and-push-it-to-ibm-cloud-container-registry-abac9b1e5246) and push it to IBM Cloud Container Registry
- Knative [Monitoring](https://medium.com/vmacwrites/knative-monitoring-with-grafana-zipkin-weavescope-other-plugins-30a2d8d20344)
