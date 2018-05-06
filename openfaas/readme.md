# OpenFaaS with Kubernetes on Minikube

Serverless Functions Made Simple for Kubernetes

[OpenFaaS site](https://www.openfaas.com) is rapidly changing and improving project.

## Setting up OpeFaaS on Kubernetes

### Kubernetes setup

1. Install [Minikube](https://kubernetes.io/docs/getting-started-guides/minikube/) (or any other Kubernetes cluster)
1. Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) command line tool for Kubernetes
1. Install [Helm](https://docs.helm.sh/using_helm/), a package manager for Kubernetes based applications
1. Start Minikube: `minikube start --kubernetes-version v1.9.4 --cpus 4 --memory 8000 --disk-size 80g -p minikube-openfaas`
1. Use profile specified above: `minikube profile minikube-openfaas`
1. Verify `minikube status` and `kubectl version` run correctly

## Setup Helm

Create a service account for Helm’s server component (Tiller) and initialize Helm:

``` sh
kubectl -n kube-system create sa tiller && kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
helm init --skip-refresh --upgrade --service-account tiller
```

## Install OpenFaaS

Alex Ellis and team has done great work related to
[getting started](https://medium.com/devopslinks/getting-started-with-openfaas-on-minikube-634502c7acdf).

The instruction below follow the above Getting Started instructions. As an enhancement, this deploys to a created namespace `openfaas` instead of the default namespace. Hopefully, this will all be in a stable helm chart in the coming months.

### CLI install

Install faas-cli from here: https://github.com/openfaas/faas-cli/releases. Once installed you should see the minimal version of 0.6.8, you may have something later.

``` sh
faas-cli version
```

### Controller install

``` sh
git clone https://github.com/openfaas/faas-netes && cd faas-netes
kubectl create namespace openfaas && kubectl create namespace openfaas-fn
helm upgrade --install openfaas chart/openfaas/ --namespace openfaas --set functionNamespace=openfaas-fn --set rbac=false
```

Minikube is not configured for RBAC, therefore an additional flag is present to turn it off.

--------------------------------

## Installation confirmation

In the namespace openfaas there will be 4 main deployments. Type `minikube service list` to the list of exposed services that your browser and point to. To see the OpenFaaS UI access it via the external NodePort:

`minikube service -n openfaas gateway-external`

## Install Some Samples

--------------------------------

### NodeInfo Function

Open the UI and add the NodeInfo function from the store.

`minikube service -n openfaas gateway-external`

Exercise the function right in the UI. If it returns an error, give it a few more seconds to start.

More on this function can be found here: https://github.com/openfaas/faas/tree/master/sample-functions/NodeInfo


--------------------------------

### Text-To-Speech Function

Open the UI and add the OpenFaaS text-to-speech function from the store.

`minikube service -n openfaas gateway-external`

Once the speech function is available, exercise it with this command

``` sh
curl $(minikube service -n openfaas gateway-external --url)/function/text-to-speech
-d 'No animal has been harmed in this conversion. Would you like to play a game?' > output.mp3
```

To confirm the audio
`start output.mp3`

More on this function can be found here: https://github.com/rorpage/openfaas-text-to-speech

--------------------------------

### Inception Function

Open the UI and add the Inception function from the store.

`minikube service -n openfaas gateway-external`

Check the Kubernetes dashboard and wait until the inception[...] pod has started and appears with the green status. When ready, in the OpenFaaS UI for Inception select json and paste in this image URL as the request body:

https://images-na.ssl-images-amazon.com/images/I/71JcfZ9e2mL._SX355_.jpg

The function will return with a 500 error, but if you check the pod's log it echoes the correct result.

Another image to try is:

https://upload.wikimedia.org/wikipedia/commons/6/61/Humpback_Whale_underwater_shot.jpg

--------------------------------

### More Services

The faas-cli tool allows you to submit function declarative definitions. A yaml file is used to define the functions to be added.

``` sh
faas-cli --gateway $(minikube service -n openfaas gateway-external --url) deploy -f samples.yaml
```

--------------------------------

### Monitoring Exploration

Take a look at the Prometheus. Open the service at

`
minikube service -n openfaas prometheus-external
`

and selection metric "gateway_function_invocation_total"

Now hit a function and notice the metrics increase in values

See this metric

```
sum(rate(gateway_function_invocation_total{code="200"}[10s])) BY (function_name)
```

Slow rate:

```
sum(rate(gateway_function_invocation_total{code="200"}[10s])) BY (function_name)
```

Then remove the -4 to increase rate and see scaling kick in.
