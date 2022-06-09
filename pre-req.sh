#!/bin/bash

#----
checkfile(){
    f=$1
    [ ! -f $f ] && echo "File $f not present. Aborting..." && exit 1 
} 
#----

read -p "Enter namespace [argo]: " namespace 
namespace=${namespace:-argo}
read -p "Enter client id for oidc application: " clientid 
[ -z $clientid ] && echo "Please run again by passing clientid. Aborting..." && exit 1 
read -p "Enter Client Secret for oidc application.: " clientsecret
[ -z $clientsecret ] && echo "Please run again by passing clientid. Aborting..." && exit 1
echo " "
read -p "Enter LoadBalancer IP for dex [127.0.0.1]: " lb 
#Delete Secret if alredy exist
echo "namespace : $namespace"
kubectl delete secret generic argo-workflows-sso -n $namespace 1> /dev/null 2>&1
kubectl delete secret tls tls-secret -n $namespace 1> /dev/null 2>&1
kubectl delete configmap dex-ca -n $namespace 1> /dev/null 2>&1
#generate certificate
./genratecert.sh $lb 
checkfile ssl/rootCA.crt
checkfile ssl/server.crt
checkfile ssl/server.key
# Create namespace 
kubectl create ns $namespace 
# Create argo-workflow-sso secret 
kubectl create secret generic argo-workflows-sso --from-literal=client-id=${clientid} --from-literal=client-secret=${clientsecret} -n $namespace
# Create TLS Secret for dex
kubectl create secret tls tls-secret --cert=ssl/server.crt --key=ssl/server.key -n $namespace 
# Create Configmap with ca file which will be added to argo server deployment
kubectl create configmap dex-ca --from-file ca.crt=ssl/rootCA.crt -n $namespace 
#Update secret in value.yaml
echo "Update Values.yaml under awdex-microsoft"


