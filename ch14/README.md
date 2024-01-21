# Chapter 14

In order to support receiving data via OTLP into Prometheus, we need to upgrade our version of Prometheus and enable the feature. That is taken care of in the [prom-values](./prom-values.yaml) file in this folder. We only need to upgrade Prometheus, so we're still using the same version of the Helm Chart that we've used up to this point.

```console
$ helm upgrade --namespace prometheus \
    --version 47.0.0 \
    --values mastering-prometheus/ch14/prom-values.yaml \
    mastering-prometheus \
    prometheus-community/kube-prometheus-stack
```

To send data to it over OTLP, ensure that you port-forward to Prometheus before running `otelcol` locally.

```console
$ kubectl port-forward svc/mastering-prometheus-kube-prometheus 9090:9090
```

Then:

```console
$ otelcol --config=mastering-prometheus/ch14/otelcol-config-prom.yaml
```
