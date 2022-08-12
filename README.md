# GitOps-interview

# Solution

instal flux in to k8s cluster 

```
kubectl config current-context
kubectl get nodes
kubectl create ns flux
curl -s https://fluxcd.io/install.sh | sudo bash
. <(flux completion bash)
```

Make sure to have your Git credentials:
```
export GITHUB_TOKEN=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
export GITHUB_USER=AHMTCNSVR

```

Check prerequisites for flux 
```
flux check --pre
```

we want to install Flux into our Kubernetes cluster, this is done with the Flux bootstrap command:

```
flux bootstrap github \
  --owner=$GITHUB_USER \
  --repository=GitOps-interview \
  --branch=main \
  --path=./clusters/my-cluster \
  --personal

```


