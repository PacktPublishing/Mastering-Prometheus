{
    'out/rulesA.yaml': std.manifestYamlDoc(
        (import 'variables_prometheus.jsonnet')
    ),
    'out/rulesB.yaml': std.manifestYamlDoc(
        (import 'assert.jsonnet')
    )
}
