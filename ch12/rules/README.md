# Chapter 12 Rules
To generate the rules from the Kubernetes Mixin using Jsonnet:

```console
$ cd ch12/rules
$ jb install
$ jsonnet -S -J vendor/ kubemixin.jsonnet > rules.yaml
```
