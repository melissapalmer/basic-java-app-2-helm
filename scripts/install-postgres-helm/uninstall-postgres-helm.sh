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

echoBold "This will un-install Postgres from the current kubernetes context! All volumes associated with this installtion will be destroyed!"

read -p "Are you sure want to continue (Yy)? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
	echo ""
    echoBold "Exiting the script."
    exit 0;
fi

echoBold "Removing Postgres."
helm del --purge postgres
echo ""

kubectl delete pvc data-postgres-postgresql-0