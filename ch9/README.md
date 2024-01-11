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

## Mimir
There's no Helm chart for deploying Mimir in monolithic mode. Consequently, we'll just use our own YAML manifest to create the `Deployment` and the `Service`.

```console
$ kubectl apply -f mastering-prometheus/ch9/mimir.yaml
```

Next, configure Prometheus to start sending data to it.
```console
$ helm upgrade --namespace prometheus \
    --version 47.0.0 \
    --values mastering-prometheus/ch9/prom-mimir-values.yaml \
    mastering-prometheus \
    prometheus-community/kube-prometheus-stack
```

Finally, port-forward to the Grafana instance so you can access it locally and run queries against Mimir.
```console
$ kubectl port-forward svc/mastering-prometheus-grafana 3000:80
```

Helm should've automatically provisioned the datasource for Mimir but, in case you need to do it manually, here are the steps:

1. Open http://localhost:3000 in your browser
2. Login using the credentials from [prom-mimir-values.yaml](./prom-mimir-values.yaml)
3. Add a new `Prometheus`-type datasource
   1. Use `http://mastering-prometheus-mimir.prometheus.svc.cluster.local/prometheus` as the URL
   2. Add a `Custom HTTP Header`
    1. Set `X-Scope-OrgID` as the key and `mastering-prometheus` as the value.
   3. Set the `Prometheus type` to `Mimir` with version `>2.3.x`

Now you can poke around in Grafana and try using Mimir as your datasource. Try using the Explore tab or switching the datasource to Mimir on a variety of dashboards.

When you're done, you can clean up by deleting Mimir and resetting the Prometheus deployment.

```console
$ kubectl delete -f mastering-prometheus/ch9/mimir.yaml

$ helm upgrade --namespace prometheus \
    --version 47.0.0 \
    --values mastering-prometheus/ch9/prom-values.yaml \
    mastering-prometheus \
    prometheus-community/kube-prometheus-stack
```
