# Kubeless with Kubernetes on Minikube

These best and latest instructions are adopted from the readme in the Kubeless GitHub project [here](https://github.com/kubeless/kubeless).

## Setting up Kubeless on Kubernetes

### Kubernetes setup

1. Install [Minikube](https://kubernetes.io/docs/getting-started-guides/minikube/) (or any other Kubernetes cluster)
1. Install [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) command line tool for Kubernetes
1. Install [Helm](https://docs.helm.sh/using_helm/), a package manager for Kubernetes based applications
1. Start Minikube: `minikube start --kubernetes-version v1.10.0 --cpus 4 --memory 8000 --disk-size 80g --bootstrapper localkube --profile kubeless`
1. Use profile specified above: `minikube profile kubeless`
1. Verify `minikube status` and `kubectl version` run correctly
1. Initialize Helm with: `helm init`

### Kubeless setup

Install the Kubeless CLI tool. The instructions are found in the "Assets" [here](https://github.com/kubeless/kubeless/releases).

The following script will create a namespace for Kubeless and deploy Kubeless and its handy dashboard to the namespace on your Minikube cluster:

``` sh
./deploy.sh
```

Explore deployment in dashboard

``` sh
kubectl get --namespace kubeless
minikube dashboard
```

-----------------------------

## Usage

### Run a Simple Function

From the command line deploy a simple greeting function defined in the `hello` Python code.

``` sh
kubeless function deploy greeting --runtime python2.7 --from-file hello.py --handler hello.greeting
```

See the greeting service and pod in the default namespace.

``` sh
kubectl get customresourcedefinition
kubectl get functions
kubectl get all
```

See the greeting pod and service in default namespace in the Kubernetes dashboard.

Invoke the greeting with

``` sh
kubeless function call greeting --data "G'day to the No Fluff Just Stuff community."
```

or

``` sh
kubectl proxy -p 8080 &
curl -L localhost:8080/api/v1/proxy/namespaces/default/services/greeting:http-function-port
```

See the function in the Kubeless UI:

``` sh
minikube service -n kubeless ui
```

Note: There are a few defects in the Kubeless UI where a function deployed from CLI cannot be modified in the UI. The pod starts with a failure. It's best to use the command line.

-----------------------------

### Invoke a Nodejs Function

Roadmap: Submitting this function like this does not work, thought it would.

``` sh
kubectl create -f function.yaml
curl -L localhost:8080/api/v1/proxy/namespaces/default/services/function:http-function-port

kubectl create -f function1.yaml
curl -L localhost:8080/api/v1/proxy/namespaces/default/services/function1:http-function-port
```

Extra: Add to the NodeJS script `process.exit()` to see how Kubernetes manages
the fault with its resilience features.

-----------------------------

### Using Topic Trigger with Kafka

Roadmap: Not working with 0.4.0 until a PV is created in Minikube before install. See [Quick Start Kafka example instead](http://kubeless.io/docs/quick-start/)

Deploy the script

``` sh
kubeless function deploy kafka --runtime python2.7 --handler kafka.tryKafkaTrigger --from-file kafka.py --trigger-topic holiday-greetings
```

Create a topic (TODO - may not need to do as above may create topic)

``` sh
kubeless topic create holiday-greetings
```

Publish some data on that topic

``` sh
kubeless topic publish --topic holiday-greetings --data "Peace to the World!"
```

Check the Kafka pod log in the Kubernetes dashboard to see the asynchronous echo.

-----------------------------

### Run a NodeJS Function with Parameters

Roadmap

-----------------------------

### Autoscaling excersize

Roadmap

-----------------------------

### Interact with Kubeless from serverless CLI

Roadmap: See serverless.com

-----------------------------

## Install Helm Chart for Kubeless

Roadmap:
Use the incubating public helm chart "incubator/kubeless". Prerequisite: "PV provisioner support in the underlying infrastructure."

``` sh
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator
helm install --namespace kafka --name kafka --set global.namespace=kafka incubator/kafka
helm repo add incubator https://kubernetes-charts-incubator.storage.googleapis.com/
helm install --namespace kubeless --name kubeless --set rbac.create=true --set kafkaTrigger.enabled=true --set ui.enabled=true --set controller.deployment.image.tag=v1.0.0-alpha.4 incubator/kubeless
```

## Future improvement notes

Change to provision with Helm chart
Address note about problems with UI
Add serverless.com CLI install and usage instructions
Add NodeJS examples
Remove extra directory or add instruction section for them
Review roadmap notes
Autoscaling - add demonstration examples
Use with Prometheus
