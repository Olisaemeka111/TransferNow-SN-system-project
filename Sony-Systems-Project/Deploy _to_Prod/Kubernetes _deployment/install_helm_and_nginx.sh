#!/bin/bash

set -e

# Define variables
HELM_VERSION="v3.9.0"  # Adjust to the desired Helm version
NGINX_INGRESS_CHART="ingress-nginx/ingress-nginx"
NAMESPACE="ingress-nginx"

# Function to install Helm
install_helm() {
    echo "Installing Helm ${HELM_VERSION}..."

    # Download Helm binary
    curl -fsSL -o helm.tar.gz "https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz"

    # Extract Helm binary
    tar -zxvf helm.tar.gz

    # Move Helm binary to /usr/local/bin
    sudo mv linux-amd64/helm /usr/local/bin/helm

    # Clean up
    rm -rf helm.tar.gz linux-amd64

    # Verify Helm installation
    helm version --short
}

# Function to add Helm repository
add_helm_repo() {
    echo "Adding Helm repositories..."

    helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
    helm repo update
}

# Function to install NGINX Ingress Controller
install_nginx_ingress() {
    echo "Installing NGINX Ingress Controller..."

    helm install nginx-ingress ingress-nginx/ingress-nginx \
        --namespace ${NAMESPACE} --create-namespace

    # Verify installation
    kubectl get all -n ${NAMESPACE}
}

# Function to verify installation
verify_installation() {
    echo "Verifying installation..."

    kubectl get services -n ${NAMESPACE}
    kubectl get pods -n ${NAMESPACE}
}

# Main script execution
install_helm
add_helm_repo
install_nginx_ingress
verify_installation

echo "Helm and NGINX Ingress Controller installation complete."