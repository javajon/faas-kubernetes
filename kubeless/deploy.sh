#!/bin/sh
#set -v

# Create a target namespace for the installs
kubectl create ns kubeless

# Install Kubeless engine
kubectl create -f https://github.com/kubeless/kubeless/releases/download/v0.6.0/kubeless-non-rbac-v0.6.0.yaml -n kubeless

# Install Kubeless dashboard
kubectl create -f https://raw.githubusercontent.com/kubeless/kubeless-ui/master/k8s.yaml -n kubeless

# Roadmap: 0.4.0 version requires a PV to be defined for the trigger examples
# to work. There is a note about this in the quickstart guide.
