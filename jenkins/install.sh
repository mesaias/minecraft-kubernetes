#!/bin/bash

helm repo add jenkinsci https://charts.jenkins.io

helm repo update

helm install jenkins -n jenkins -f jenkins.yaml

#helm upgrade jenkins jenkins/jenkins --namespace devops-tools -f jenkins.yaml