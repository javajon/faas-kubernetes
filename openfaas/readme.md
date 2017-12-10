# OpenFaaS with Kubernetes on Minikube #

Serverless Functions Made Simple for Docker & Kubernetes

This is rapidly changing and improving project.

Catch the buzz at the [OpenFaaS site](https://www.openfaas.com).

This tutorial com

## How do I get set up? ##

- Clone this project from GitHub
- Install [Minikube](https://kubernetes.io/docs/getting-started-guides/minikube/) 
- Install Kubectl and verify `kubectl version` runs correctly
- Start Minkube with `minkube start`

## Install OpenFaaS ##

Alex Ellis and team has done great work related to 
[getting started](https://medium.com/devopslinks/getting-started-with-openfaas-on-minikube-634502c7acdf).

From these above instructions the instructions below follow these for this
tutorial. As an enhancement, this deploys to a created namespace `openfaas` 
instead of the default namespace. Hopefull this will all be in a stable 
helm chart in the coming months.

Install faas-cli from here: https://github.com/openfaas/faas-cli/releases.
Once installed you should see the minimal version of 0.5.1, you may have
something later.

`faas-cli version`


Create a service account for Helm’s server component (tiller): 

`
kubectl -n kube-system create sa tiller && kubectl create clusterrolebinding tiller --clusterrole cluster-admin --serviceaccount=kube-system:tiller
`

Install tiller which is Helm’s server-side component: 

`
helm init --skip-refresh --upgrade --service-account tiller
`

Clone faas-netes (Kubernetes driver for OpenFaaS): 

`
git clone https://github.com/openfaas/faas-netes && cd faas-netes`

Minikube is not configured for RBAC, so we’ll pass an additional flag to turn it off: 

`
kubectl create namespace openfaas
helm upgrade --namespace openfaas --install --debug --reset-values --set async=false --set rbac=false openfaas openfaas/
`


--------------------------------
## Explore the Installation ##

In the namespace openfaas there will be 4 main deployments. Type
`minikube service list` to the list of exposed services that your
browser and point to.  

To see the OpenFaaS UI access it via the external NodePort 

minikube service -n openfaas gateway-external

## Install Some Samples ##


--------------------------------
### NodeInfo Function ###

Open the UI and add the NodeInfo function from the store.

`minikube service -n openfaas gateway-external`

Exercise the function right in the UI. If it returns an error, give 
it a a few more seconds to start.

More on this function can be found here: https://github.com/openfaas/faas/tree/master/sample-functions/NodeInfo


--------------------------------
### Text-To-Speech Function ###

Open the UI and add the text-to-speech function from the store.

`minikube service -n openfaas gateway-external`

`curl $(minikube service -n openfaas gateway-external --url)/function/text-to-speech 
-d 'No animal has been harmed in this conversion.  Would you like to play a game?' > output.mp3`

To confirm the audio
`start output.mp3`

More on this function can be found here: https://github.com/rorpage/openfaas-text-to-speech



--------------------------------
### Inception Function ###

Open the UI and add the Inception function from the store.

`minikube service -n openfaas gateway-external`

Check the Kubernetes dashboard and wait until the inception[...] pod 
has started and appears with the green status. When ready, in the OpenFaaS
UI for Inception select json and paste in this image URL as the request body: 

https://images-na.ssl-images-amazon.com/images/I/71JcfZ9e2mL._SX355_.jpg

The function will return with a 500 error, but if you check the pod's log 
it echoes the correct result.

Another image to try is:

https://upload.wikimedia.org/wikipedia/commons/6/61/Humpback_Whale_underwater_shot.jpg 



--------------------------------
### More Services ###

The faas-cli tool allows you to submit function declarative definitions. A yaml file is
used to define the functions to be added.

faas-cli --gateway $(minikube service -n openfaas gateway-external --url) deploy -f samples.yaml



--------------------------------
### Monitoring Exploration ###

Take a look at the Prometheus. Open the service at

`
minikube service -n openfaas prometheus-external
`

and selection metric "gateway_function_invocation_total"

Now hit a function and notice the metrics increase in values

See this metric

`
sum(rate(gateway_function_invocation_total{code="200"}[10s])) BY (function_name)
`

Slow rate:

`
sum(rate(gateway_function_invocation_total{code="200"}[10s])) BY (function_name)`
Then remove the -4 to increase rate and see scaling kick in.


