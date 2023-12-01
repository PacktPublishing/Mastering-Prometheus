local thanos = (import 'github.com/thanos-io/thanos/mixin/mixin.libsonnet') {
    query+:: {
        selector: 'job=~".*thanos-query.*"',
        title: '%(prefix)sQuery' % $.dashboard.prefix,
    },
    sidecar+:: {
        selector: 'job=~".*thanos-sidecar.*"',
        thanosPrometheusCommonDimensions: 'namespace, pod',
        title: '%(prefix)sSidecar' % $.dashboard.prefix,
    },
    queryFrontend:: null,
    store:: null,
    receive:: null,
    rule:: null,
    compact:: null,
    bucketReplicate:: null, 
};

{
    'out/thanos_recording_rules.yaml': std.manifestYamlDoc(thanos.prometheusRules),
    'out/thanos_alerting_rules.yaml': std.manifestYamlDoc(thanos.prometheusAlerts),
}
+
{
    ['out/dashboard_' + name]: std.manifestJson(thanos.grafanaDashboards[name])
    for name in std.objectFields(thanos.grafanaDashboards)
}
