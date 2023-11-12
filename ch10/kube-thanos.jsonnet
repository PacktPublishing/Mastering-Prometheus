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

local s = t.store(commonConfig {
  replicas: 1,
  serviceMonitor: true,
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

local q = t.query(commonConfig {
  replicas: 1,
  serviceMonitor: true,
  stores: [
    'dnssrv+_grpc._tcp.prometheus-operated.prometheus.svc.cluster.local',
    'dnssrv+_grpc._tcp.%s.prometheus.svc.cluster.local' % s.service.metadata.name,
    ],
});

local qf = t.queryFrontend(commonConfig {
  replicas: 1,
  downstreamURL: 'http://%s.%s.svc.cluster.local:%d' % [q.service.metadata.name, q.service.metadata.namespace, q.service.spec.ports[1].port],
  logQueriesLongerThan: '60s',
  serviceMonitor: true
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
    ),
  "thanos-queryfrontend.yaml": std.manifestYamlStream(
    [ qf[name] for name in std.objectFields(qf) if qf[name] != null ], quote_keys=false
    ),
  "thanos-store.yaml": std.manifestYamlStream(
    [ s[name] for name in std.objectFields(s) if s[name] != null ], quote_keys=false
    )
}
