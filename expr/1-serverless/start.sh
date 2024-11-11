#!/usr/bin/env bash
PIP=$(kubectl get -n knative-serving svc kourier -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# replace default.10.108.189.25.sslip.io:80 to default.$PIP.sslip.io:80
replace="s/default\.[0-9\.]*\.sslip\.io:80/default.$PIP.sslip.io:80/g"

sed -i '' -e "$replace" workload/DeathStarBench/hotelReservation/knative/frontend-override-config.yaml

kubectl apply -Rf workload/DeathStarBench/hotelReservation/knative