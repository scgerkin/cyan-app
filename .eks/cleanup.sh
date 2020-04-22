# clean up and delete the cluster
kubectl delete -f templates/svc-lb.yaml
kubectl delete -f templates/rc-blue.yaml
kubectl delete -f templates/rc-green.yaml
eksctl delete cluster -f cluster/stack.yaml
