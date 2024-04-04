#!/bin/bash

helm upgrade prometheus prometheus-community/prometheus --namespace prometheus \
  --set server.persistentVolume.enabled=true \
  --set server.persistentVolume.storageClass=local-storage \
  --set server.persistentVolume.existingClaim=prometheus-pvc


  helm upgrade grafana grafana/grafana --namespace grafana --set persistence.enabled=true,persistence.storageClassName="local-storage",persistence.existingClaim="grafana-pvc" --values grafana_values.yaml