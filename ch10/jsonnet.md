# Jsonnet
This chapter leverages the [kube-thanos](https://github.com/thanos-io/kube-thanos/) Jsonnet library.

To generate the YAML files in [manifests](./manifests/), you must install [jsonnet](http://jsonnet.org/) and [jsonnet-bundler](https://github.com/jsonnet-bundler/jsonnet-bundler#install).

With those installed, you can install dependencies by running:
```console
$ jb install
```

Then you are able to generate manifests using the [Makefile](./Makefile) by running:
```console
$ make kube-thanos
```
