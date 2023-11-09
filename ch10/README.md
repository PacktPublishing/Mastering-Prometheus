# Chapter 10

## Thanos Sidecar
Install the boto3 dependency to use the Object Storage features of `linode-cli`
```console
$ pip3 install --user boto3
```

Set up a Linode Object Storage bucket and access key (choose whatever cluster you want):
```console
$ linode-cli obj --cluster us-ord-1 \
    mb \
    mastering-prometheus-thanos

$ linode-cli object-storage \
    keys-create \
    --label=mastering-prometheus-thanos \
    --bucket_access.cluster=us-ord-1 \
    --bucket_access.bucket_name=mastering-prometheus-thanos \
    --bucket_access.permissions=read_write
```

!! Make note of the `access_key` and `secret_key` returned by the CLI. We'll need them later.

Create a Kubernetes `Secret` containing the configuration Thanos will use for connecting to object storage by editing [thanos-objstore-config.yaml](./thanos-objstore-config.yaml) to substitute your own values for `access_key` and `secret_key`. If you used a different cluster than `us-ord-1`, then substitute that part, too (the `.linodeobjects.com` suffix will be the same).

Apply that `Secret` by running:
```console
$ kubectl apply -f mastering-prometheus/ch10/thanos-objstore-config.yaml
```

Now we can finally use our updated Helm values for the `kube-prometheus-stack` chart to deploy Thanos Sidecar, referencing that `Secret`:

```console
$ helm upgrade --namespace prometheus \
    --version 47.0.0 \
    --values mastering-prometheus/ch10/sidecar-values.yaml \
    mastering-prometheus \
    prometheus-community/kube-prometheus-stack
```

We'll now have a `thanos-sidecar` container running within all of our Prometheus pods, uploading new TSDB blocks to object storage. Since we're not uploading already compacted blocks, we'll need to wait a few hours for a new block to be written out and uploaded.

## Thanos Compact
Ensure that you completed the steps in the [Thanos Sidecar](#thanos-sidecar) section to create the `thanos-objstore-config` Secret, then apply the [manifest](./manifests/thanos-compact.yaml) in this repo.

```console
$ kubectl apply -f mastering-prometheus/ch10/manifests/thanos-compact.yaml
```

## Thanos Query
Ensure that your Thanos Sidecars are deployed, then apply the [manifest](./manifests/thanos-query.yaml) in this repo.

```console
$ kubectl apply -f mastering-prometheus/ch10/manifests/thanos-query.yaml
```

You can access the UI by port-forwarding to the Service like so:

```console
$ kubectl port-forward svc/thanos-query 9090
```

## Cleanup

When you're done, you can clean up by resetting the Prometheus deployment.

```console

$ helm upgrade --namespace prometheus \
    --version 47.0.0 \
    --values mastering-prometheus/ch10/prom-values.yaml \
    mastering-prometheus \
    prometheus-community/kube-prometheus-stack
```

And removing the Thanos object storage secret:

```console
$ kubectl delete secret thanos-objstore-config 
```

And removing the manifests we deployed:
```console
$ kubectl delete -f mastering-prometheus/ch10/manifests
```

Finally, if you're not using Linode Object Storage for anything else, you can cancel your Object Storage service by following this guide: https://www.linode.com/docs/products/storage/object-storage/guides/cancel/
If you do not cancel the service, you will continue to be charged a small monthly fee regardless of whether or not you have any buckets in use.
