# Knative-deploy

Step-by-step instructions to install Knative with Istio 1.0.2 on IBM Cloud Kubernetes Service(IKS), build and push your image to IBM Cloud Container Registry and deploy the app.

> Rehash of [helloworld-nodejs](https://github.com/knative/docs/tree/master/serving/samples/helloworld-nodejs)

### Prerequisites

- [git](https://git-scm.com/downloads)
- [Node and npm](https://www.npmjs.com/get-npm)
- [Download and install the ibmcloud command line tool](https://console.bluemix.net/docs/cli/index.html#overview)

### Setup CLI
> If you already have ibmcloud installed with the ibmcloud cs plugin, you can skip these steps.

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
  kubectl apply --filename kubectl apply --filename https://raw.githubusercontent.com/knative/serving/master/third_party/istio-1.0.2/istio.yaml
```

- Label the default namespace with istio-injection=enabled:
 `kubectl label namespace default istio-injection=enabled`
- Monitor the Istio components until all of the components show a STATUS of Running or Completed:
`kubectl get pods --namespace istio-system`

- [Installing Knative components](https://github.com/knative/docs/blob/master/install/Knative-with-IKS.md#installing-knative-components)


### Build and Deploy the app

- Clone the repo
```
  git clone https://github.ibm.com/vidyasagar-msc/knative-deploy.git
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