#!/usr/bin/env bash
POD=$(kubectl get pods -l app=wrk -o jsonpath='{.items[].metadata.name}')


kubectl cp workload/DeathStarBench/hotelReservation/wrk2/scripts/hotel-reservation/mixed-workload_type_1.lua $POD:/root/

RQST_PER_SEC=(10 100 500 1000)
GAP_TIME=(15)

for rps in ${RQST_PER_SEC[@]}; do
  for gap in ${GAP_TIME[@]}; do
    echo
    echo --------------------------------
    echo Start Time: $(date)
    echo "RPS: $rps, GAP: $gap"
    echo --------------------------------
    echo
    kubectl exec -it $POD -- wrk -D exp -t 1 -c 1 -d 30 -L -s /root/mixed-workload_type_1.lua -R $rps http://frontend.default.svc.cluster.local:5000
    echo
    echo --------------------------------
    echo End Time: $(date)
    echo --------------------------------
    echo
    sleep $gap
  done
done
