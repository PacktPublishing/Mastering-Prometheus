local k = import 'kubernetes-mixin/mixin.libsonnet';

{
    'rules.yaml': std.manifestYamlDoc(k.prometheusRules + k.prometheusAlerts)
}
