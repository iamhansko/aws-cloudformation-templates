#!/bin/bash

# Multus CNI 설치 스크립트
set -e

echo "Installing Multus CNI on EKS cluster..."

# Multus CNI DaemonSet 설치
kubectl apply -f https://raw.githubusercontent.com/k8snetworkplumbingwg/multus-cni/master/deployments/multus-daemonset-thick.yml

# 설치 상태 확인
echo "Waiting for Multus pods to be ready..."
kubectl wait --for=condition=ready pod -l app=multus -n kube-system --timeout=300s

# Multus 설치 확인
echo "Verifying Multus installation..."
kubectl get pods -n kube-system -l app=multus

echo "Multus CNI installation completed successfully!"