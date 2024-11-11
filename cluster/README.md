## Connect to CloudLab

1. ssh into the CloudLab node.
2. Copy scripts/export-kube-config.sh to the terminal and run it.
3. Copy the export kubeconfig.yml into kubeconfig/3n.yml
4. Source scripts/set-kube-config.sh in your working terminal, e.g., `. scripts/set-kube-config.sh`.
5. You should now be able to run kubectl commands. Note: for each new terminal, you will need to source set-kube-config.sh again. Or you can replace the kubeconfig file in ~/.kube/config with the one in kubeconfig/3n.yml.