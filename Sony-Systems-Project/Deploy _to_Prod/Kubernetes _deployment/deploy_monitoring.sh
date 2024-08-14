#!/bin/bash

set -e

# Define variables
PROMETHEUS_NAMESPACE="monitoring"
PROMETHEUS_RELEASE_NAME="prometheus"
GRAFANA_NAMESPACE="monitoring"
GRAFANA_RELEASE_NAME="grafana"

# Add Helm repositories
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

# Create namespace for monitoring
kubectl create namespace ${PROMETHEUS_NAMESPACE} || echo "Namespace ${PROMETHEUS_NAMESPACE} already exists"

# Deploy Prometheus
helm install ${PROMETHEUS_RELEASE_NAME} prometheus-community/prometheus \
    --namespace ${PROMETHEUS_NAMESPACE} \
    --create-namespace

# Deploy Grafana
helm install ${GRAFANA_RELEASE_NAME} grafana/grafana \
    --namespace ${GRAFANA_NAMESPACE} \
    --create-namespace \
    --set adminPassword='admin'

# Verify deployments
kubectl get all -n ${PROMETHEUS_NAMESPACE}
kubectl get all -n ${GRAFANA_NAMESPACE}

# Print instructions for accessing Grafana
echo "Grafana has been deployed. Access it by running:"
echo "kubectl port-forward service/grafana 3000:80 -n ${GRAFANA_NAMESPACE}"
