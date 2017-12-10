# Kubeless with Kubernetes on Minikube #

These best and latest instructions are in the readme for the Kubeless GitHub project  
[here](https://github.com/kubeless/kubeless).

### How do I get set up? ###

- Clone this project from GitHub
- Install [Minikube](https://kubernetes.io/docs/getting-started-guides/minikube/) 
- Install Kubectl and verify `kubectl version` runs correctly
- Start Minkube with `minkube start`

### Install Kubeless ###

Note: Avoid version v0.3.0 due to [Zookeeper error](https://github.com/kubeless/kubeless/issues/480). These instructions 
were tested with v0.2.4.

Install the Kubeless CLI tool. The instructions are found in the 
"Assets" [here](https://github.com/kubeless/kubeless/releases).

Side note: Wouldn't it be nice if there was a helm chart for these serverless projects. e.g. `helm search`

Create a namespace for kubeless

`kubectl create ns kubeless`

Deploy Kubeless to the kubeless namespace on your Minikube cluster

`
kubectl create -f https://github.com/kubeless/kubeless/releases/download/v0.2.4/kubeless-v0.2.4.yaml
`

Explore deployment in dashboard/kubectl

`minikube dashboard`

Notice in the namespace the deployments will take a few minutes before they report as ready.

Kubeless has a handy dashboard too. Enable it with this command.

`
kubectl create -f https://raw.githubusercontent.com/kubeless/kubeless-ui/master/k8s.yaml
`

-----------------------------
### Run a Simple Function ###

From the command line deploy a simple greeting function.

`cat hello.py`

`
kubeless function deploy greeting --runtime python2.7 --from-file hello.py --handler hello.greeting --trigger-http
`

`kubeless function ls`
							
See the greeting pod loading in default namespace in the Kubernetes dashboard.

See the function in the Kubeless UI:

`
minikube service -n kubeless ui
`

Invoke the function in the UI or command line:

`
kubeless function call greeting
`

Note: There is a defect in Kubeless where a function deployed from CLI cannot be 
modified in the UI. The pod starts with a failure. For these steps create a new function in the UI.
- In the UI modify the function and notice the function instantly changes without redeployment.
- Next, mess with the pod and add to the NodeJS script `process.exit()`. Notice how Kubernetes manages the 
fault with its resilience features.



----------------------------------------
### Using a topic Trigger with Kafka ###
`cat kafka.py`

Deploy the script
`
kubeless function deploy kafka --runtime python2.7 --handler kafka.tryKafkaTrigger --from-file kafka.py --trigger-topic test-topic
`

Create a topic
`
kubeless topic create holiday-greetings
`

Publish come data on the topic
`
kubeless topic publish --topic holiday-greetings --data "Peace to the World!"
`

Check the kafka pod log in the Kubernetes dashboard to see the echo


---------------------------------------------
### Run a NodeJS Function with Parameters ###

Note: Problems were experienced with getting this to work in v0.2.4, awaiting version after v0.3.0
https://medium.com/bitnami-perspectives/deploying-a-kubeless-function-using-serverless-templates-2d03f49b70e2

