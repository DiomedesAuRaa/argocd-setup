#!/bin/bash

# Variables
ARGOCD_NAMESPACE="argocd"
HELM_REPO_NAME="argo"
HELM_REPO_URL="https://argoproj.github.io/argo-helm"
HELM_CHART_NAME="argo-cd"
HELM_RELEASE_NAME="argocd"
INGRESS_HOST="argocd.example.com" # Change this to your domain

# Step 1: Add Argo CD Helm repository
echo "Adding Argo CD Helm repository..."
helm repo add $HELM_REPO_NAME $HELM_REPO_URL
helm repo update

# Step 2: Create the Argo CD namespace
echo "Creating namespace '$ARGOCD_NAMESPACE'..."
kubectl create namespace $ARGOCD_NAMESPACE --dry-run=client -o yaml | kubectl apply -f -

# Step 3: Deploy Argo CD using Helm
echo "Deploying Argo CD in '$ARGOCD_NAMESPACE' namespace..."
helm install $HELM_RELEASE_NAME $HELM_REPO_NAME/$HELM_CHART_NAME \
  --namespace $ARGOCD_NAMESPACE \
  --set controller.replicas=3 \
  --set redis-ha.enabled=true \
  --set server.ingress.enabled=true \
  --set server.ingress.hosts[0]=$INGRESS_HOST \
  --set server.ingress.annotations."nginx\.ingress\.kubernetes\.io/force-ssl-redirect"=\"true\" \
  --set server.ingress.annotations."nginx\.ingress\.kubernetes\.io/ssl-redirect"=\"true\"

# Step 4: Wait for Argo CD to be ready
echo "Waiting for Argo CD to be ready..."
kubectl wait --for=condition=available deployment/argocd-server -n $ARGOCD_NAMESPACE --timeout=300s

# Step 5: Get the Argo CD admin password
ARGOCD_PASSWORD=$(kubectl -n $ARGOCD_NAMESPACE get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)

echo "Argo CD deployment complete! Check the README.md file for details."