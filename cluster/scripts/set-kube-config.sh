#!/usr/bin/env bash
name=${1:-3n}
echo Using Cluster: $name
echo "---"
export KUBECONFIG="$(cd "$(dirname "$0")" && cd .. && pwd)/kubeconfig/$name.yml"
echo KUBECONFIG=$KUBECONFIG
echo "---"
echo "kubectl config view"
kubectl config view
echo "---"
kubectl get nodes