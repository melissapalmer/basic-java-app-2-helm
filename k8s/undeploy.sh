#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

echoBold(){
   echo "${bold}$1${normal}"
}

echoBold "Un-Deploying docker-2-helm..."

echoBold "Deleting Ingresses..."
kubectl delete -f artifacts/docker-2-helm-ingress.yaml

echoBold "Deleting Services..."
kubectl delete -f artifacts/docker-2-helm-service.yaml

echoBold "Deleting Deployment..."
kubectl delete -f artifacts/docker-2-helm-deployment.yaml

echoBold "Deleting docker-2-helm Config maps"
kubectl delete configmap docker-2-helm-configuration

