# GitOps-interview

# Solutions

#  1 . setting up the enviroment 

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
# 2. Helm  Chart deployment with flux ( Starboard )

first lets create namespace 


```
kubectl create ns starboard-system
```
or 

```
kubectl apply -f namespace.yaml 
```


```
flux create source helm starboard-operator --url <https://aquasecurity.github.io/helm-charts> --namespace starboard-system
flux create helmrelease starboard-operator --chart starboard-operator **\\**
  --source HelmRepository/starboard-operator **\\**
  --chart-version 0.10.3 **\\**
  --namespace starboard-system
```

it is also possible to install helm realease by kubernetees manifests

```
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: HelmRepository
metadata:
  name: starboard-operator
  namespace: flux-system
spec:
  interval: 1m0s
  url: <https://aquasecurity.github.io/helm-charts/>

---
apiVersion: helm.toolkit.fluxcd.io/v2beta1
kind: HelmRelease
metadata:
  name: starboard-operator
  namespace: starboard-system
spec:
  chart:
    spec:
      chart: starboard-operator
      sourceRef:
        kind: HelmRepository
        name: starboard-operator
				namespace: flux-system
      version: 0.10.3
  interval: 1m0s
```
then 

```
kubectl apply -f starboard.yaml
```

# react application deployment with flux 

```
apiVersion: source.toolkit.fluxcd.io/v1beta2
kind: GitRepository
metadata:
  name: react-app
  namespace: flux-system
spec:
  interval: 1m
  url: https://github.com/AHMTCNSVR/react-display.git
  ref:
    branch: main
  ignore: |
    # exclude all
    /*
    # include charts directory
    !/deploy/manifests/
---
apiVersion: kustomize.toolkit.fluxcd.io/v1beta2
kind: Kustomization
metadata:
  name: react-app
  namespace: flux-system
spec:
  interval: 5m0s
  path: ./deploy/manifests
  prune: true
  sourceRef:
    kind: GitRepository
    name: react-app
  targetNamespace: app
```
then 
```
kubectl apply -f app.yaml
```

imprerative way of deployment 

```
flux create source git react \\
    --url=https://github.com/AHMTCNSVR/react-display \\
    --branch=main
```


lets tell flux where our applications k8s manifes

```
flux create kustomization react-app \\
  --target-namespace=app \\
  --source=react \\
  --path="./deploy/manifests" \\
  --prune=true \\
  --interval=5m \\

```






