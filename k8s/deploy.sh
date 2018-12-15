#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

echoBold(){
   echo "${bold}$1${normal}"
}

echoBold "Deploying docker-2-helm..."

echoBold "Provisioning Persistent Volumes..."
echo "No persistent volumes currently being provisioned for docker-2-helm, all state is lost between deployments!"

echoBold "Creating docker-2-helm Config maps"
kubectl create configmap docker-2-helm-configuration --from-file=config/application.yml

echoBold "Creating Deployment..."
kubectl create -f artifacts/docker-2-helm-deployment.yaml

echoBold "Creating Services..."
kubectl create -f artifacts/docker-2-helm-service.yaml

echoBold "Creating Ingresses..."
kubectl create -f artifacts/docker-2-helm-ingress.yaml
