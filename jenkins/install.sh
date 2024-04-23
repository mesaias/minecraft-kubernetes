#!/bin/bash

helm repo add jenkins https://charts.jenkins.io

helm repo update

kubectl create namespace jenkins

helm upgrade --install jenkins jenkins/jenkins -f jenkins.yaml -n jenkins

kubectl create clusterrolebinding permissive-binding --clusterrole=cluster-admin --user=admin --user=kubelet --group=system:serviceaccounts

#helm upgrade jenkins jenkins/jenkins --namespace devops-tools -f jenkins.yaml