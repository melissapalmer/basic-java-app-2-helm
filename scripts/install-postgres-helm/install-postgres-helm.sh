#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

echoBold(){
   echo "${bold}$1${normal}"
}

echoBold "Getting cluster information and context. Please ensure that the correct kubectl context is being used!"
echo ""

echoBold "Cluster Information"
kubectl cluster-info

if [ $? -eq 0 ]; then
	echo ""
    echo "Cluster connection successful."
else
	echo ""
    echoBold "Unable to connect to cluster. Exiting the script."
    exit 1;
fi
echo ""

echoBold "Current Context:"
kubectl config current-context
echo ""

echoBold "This will install Postgres into the current kubernetes context!!"

read -p "Are you sure want to continue (Yy)? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo ""
    echoBold "Exiting the script."
    exit 0;
fi

echoBold "Installing Postgres"
helm install --name postgres --replace -f postgres-values.yaml stable/postgresql


