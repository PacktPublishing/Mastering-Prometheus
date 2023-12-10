local k = import 'kubernetes-mixin/mixin.libsonnet';

std.manifestYamlDoc(k.prometheusAlerts)
