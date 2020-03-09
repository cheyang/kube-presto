Presto with Kubernetes
======================

Code snippets and notes on running Presto with Kubernetes.

Credits:
Some code are based on [Joshua Robison](https://github.com/joshuarobinson)'s awesome work.

# Deploy a Presto Cluster
The below deploys a Presto cluster in the `warehouse` name space.
Create config maps.
```
./create-configmap.sh
```

Deploy a Presto cluster.
```
kubectl create -f presto-server.yaml
```