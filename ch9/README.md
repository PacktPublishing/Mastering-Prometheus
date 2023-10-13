# Chapter 9

## VictoriaMetrics
Add the Helm repository:

```console
$ helm repo add vm https://victoriametrics.github.io/helm-charts/
$ helm repo update
```

Deploy the chart:

```console
$ helm install \
    --namespace prometheus \
    --values mastering-prometheus/ch9/vm-values.yaml \
    --version 0.9.10 \
    vmsingle \
    vm/victoria-metrics-single
```

Update Prometheus to send data to VictoriaMetrics:

```console
$ helm upgrade --namespace prometheus \
    --version 47.0.0 \
    --values mastering-prometheus/ch9/prom-vm-values.yaml \
    mastering-prometheus \
    prometheus-community/kube-prometheus-stack
```

When finished, uninstall VictoriaMetrics and remove the remote write config from Prometheus by running:

```console
$ helm uninstall vmsingle --namespace prometheus

$ helm upgrade --namespace prometheus \
    --version 47.0.0 \
    --values mastering-prometheus/ch9/prom-values.yaml \
    mastering-prometheus \
    prometheus-community/kube-prometheus-stack
```
