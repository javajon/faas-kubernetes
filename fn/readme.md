DRAFT: These instructions are incomplete

The Fn project is an open source, container native, and cloud agnostic
serverless platform. It’s easy to use, supports every programming language,
and is extensible and performant.

1. Install
   a. Kubernetes (Minikube is a good start)
   b. KubeCtl
   c. Set your environment to the Minikube context with `eval $(minikube docker-env)`

2. FN setup
   a. Install the [FN CLI tool](https://github.com/fnproject/fn#install-cli-tool)
   b. git clone http://github.com/fnproject/fn-helm.git && cd fn-helm
   c. helm dependency build fn
   d. helm install --name my-fn -f examples/minikube/values.yaml fn

   export POD_NAME=$(kubectl get pods --namespace default -l "app=my-fn-fn,role=fn-service" -o jsonpath="{.items[0].metadata.name}")
   kubectl port-forward --namespace default $POD_NAME 8080:80 &
