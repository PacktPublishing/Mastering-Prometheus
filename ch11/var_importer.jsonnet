local i = import 'imported.libsonnet';

i {
    monitoringStack+: ['thanos']
}
