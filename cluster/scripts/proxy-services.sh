#!/usr/bin/env bash
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 3000:443 & \
kubectl -n monitoring port-forward svc/prometheus-grafana 3001:80 & \
kubectl -n monitoring port-forward svc/prometheus-kube-prometheus-prometheus 3002:9090 & \
kubectl -n monitoring port-forward svc/prometheus-kube-prometheus-alertmanager 3003:9093 & \

echo "Press CTRL-C to stop port forwarding and exit the script"
wait