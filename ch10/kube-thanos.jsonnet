local t = import 'kube-thanos/thanos.libsonnet';

local commonConfig = {
    local cfg = self,
    namespace: 'prometheus',
    version: 'v0.31.0',
    image: 'quay.io/thanos/thanos:' + cfg.version,
    imagePullPolicy: 'IfNotPresent',
    replicaLabels: ['prometheus_replica'],
    objectStorageConfig: {
      name: 'thanos-objstore-config',
      key: 'thanos.yaml',
    },
};

local c = t.compact(commonConfig {
  replicas: 1,
  serviceMonitor: true,
  disableDownsampling: false,
  deduplicationReplicaLabels: super.replicaLabels,  // reuse same labels for deduplication
})
+ {
  statefulSet+: {
    spec+:{
      template+:{
        spec+:{
          volumes+: [
            {
              emptyDir: {},
              name: "data"
            }
          ]
        }
      }
    }
  },
};

// local s = t.store(commonConfig {
//   replicas: 1,
//   serviceMonitor: true,
// });

local q = t.query(commonConfig {
  replicas: 1,
  serviceMonitor: true,
  stores: ['dnssrv+_grpc._tcp.prometheus-operated.prometheus.svc.cluster.local'],
});

// { ['thanos-store-' + name]: s[name] for name in std.objectFields(s) } +
// { ['thanos-query-' + name]: q[name] for name in std.objectFields(q) } +
// std.manifestYamlStream(
//   { ['thanos-compact-' + name + 'yaml']: c[name] for name in std.objectFields(c) if c[name] != null }
// )


{
  "thanos-compact.yaml": std.manifestYamlStream(
      [ c[name] for name in std.objectFields(c) if c[name] != null ], quote_keys=false
    ),
  "thanos-query.yaml": std.manifestYamlStream(
      [ q[name] for name in std.objectFields(q) if q[name] != null ], quote_keys=false
    )
}
