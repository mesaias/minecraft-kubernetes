#!/bin/bash

kubectl create namespace prometheus
# add prometheus Helm repo and install
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/prometheus --namespace prometheus
kubectl patch ds prometheus-prometheus-node-exporter --namespace prometheus --type "json" -p '[{"op": "remove", "path" : "/spec/template/spec/containers/0/volumeMounts/2/mountPropagation"}]'

kubectl create namespace grafana
# add and install grafana
helm repo add grafana https://grafana.github.io/helm-charts 
helm repo update
helm install grafana grafana/grafana --namespace grafana

helm repo add prometheus-community https://prometheus-community.github.io/helm-chartshelm 
repo update helm install kube-state-metrics prometheus-community/kube-state-metrics -n kube-system


#helm uninstall prometheus

#https://semaphoreci.com/blog/prometheus-grafana-kubernetes-helm

#helm upgrade prometheus --namespace prometheus -f prometheus-values.yaml