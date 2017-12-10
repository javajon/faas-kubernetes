#!/bin/sh
set -v

kubectl create ns kubeless

# Install Kubeless
# Avoid version v0.3.0 due to [Zookeeper error](https://github.com/kubeless/kubeless/issues/480).
kubectl create -f https://github.com/kubeless/kubeless/releases/download/v0.2.4/kubeless-v0.2.4.yaml

# Install the UI for Kubeless
kubectl create -f https://raw.githubusercontent.com/kubeless/kubeless-ui/master/k8s.yaml
