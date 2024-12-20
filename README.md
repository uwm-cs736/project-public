
## Folder Structure

- cluster: k8s cluster setup
  - helm: helm charts for kubernetes dashboard and prometheus
  - kubeconfig: kubeconfig files export by export-kube-config.sh, and will be used by set-kube-config.sh.
  - kubectl: raw kubernetes yaml files for knative related resources and wrk2.
  - scripts:
    - export-kube-config.sh: export kubeconfig files from k8s cluster. should be run in k8s master node.
    - set-kube-config.sh: set KUBECONFIG environment variable to use kubeconfig files in kubeconfig. default to 3n.yml.
    - proxy-services.sh: port forward services to localhost.
- expr:
  - 1-container: container form expr, will load application in workload/DeathStarBench/hotelReservation/kubernetes
  - 1-serverless: serverless form expr, will load application in workload/DeathStarBench/hotelReservation/knative
- output: output of expr, test.txt is the result of wrk2 test.
- workload: DeathStarBench workload, hotelReservation is used in this expr.
- Makefile: including many useful commands for running expr and printing status for the cluster.
- ctf: terraform shortcut wrapper

## How to Run

1. Get a CloudLab k8s experiment ready.
2. Copy export-kube-config.sh to the main node's terminal and copy the output of kubeconfig to cluster/kubeconfig/3n.yml.
3. Run `source cluster/scripts/set-kube-config.sh` to set KUBECONFIG environment variable.
4. Run `./ctf aa` to apply the k8s resources. Depending on the cluster status, it may take multiple tries.
5. Run tests:
   1. `make expr NAME=${name:-1-container}`: get the application ready.
   2. `make node_pending`: output all pending node, wait until all nodes to be ready, then continuie.
   3. `make expr_test NAME=${name}`: run the workload generator.
   4. `make expr_stop NAME=${name}`: clean the application, return the cluster to original state.

## Visit Dashboard and Grafana

1. Run `./cluster/scripts/proxy-services.sh` to port forward services to localhost.
2. Visit `http://localhost:3000` for kubernetes dashboard.
3. Run `./ctf token` to get the token for kubernetes dashboard (remove the trailing % in the ouput if there is any).
4. Visit `http://localhost:3001` for Grafana. The username is `admin`, and the password is `prom-operator`.