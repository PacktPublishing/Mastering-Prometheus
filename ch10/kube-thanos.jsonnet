local t = import 'kube-thanos/thanos.libsonnet';
local tmix = (import 'mixin/rules/rules.libsonnet') + (import 'mixin/config.libsonnet');

local useEmptyDir(sts) = sts + {
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

local c = useEmptyDir(t.compact(commonConfig {
  replicas: 1,
  serviceMonitor: true,
  disableDownsampling: false,
  deduplicationReplicaLabels: super.replicaLabels,  // reuse same labels for deduplication
}));


local s = useEmptyDir(t.store(commonConfig {
  replicas: 1,
  serviceMonitor: true,
}));

local q = t.query(commonConfig {
  replicas: 1,
  serviceMonitor: true,
  stores: [
    'dnssrv+_grpc._tcp.prometheus-operated.prometheus.svc.cluster.local',
    'dnssrv+_grpc._tcp.%s.prometheus.svc.cluster.local' % s.service.metadata.name,
    'dnssrv+_grpc._tcp.thanos-rule.%s.svc.cluster.local' % commonConfig.namespace,
    ],
});

local qf = t.queryFrontend(commonConfig {
  replicas: 1,
  downstreamURL: 'http://%s.%s.svc.cluster.local:%d' % [q.service.metadata.name, q.service.metadata.namespace, q.service.spec.ports[1].port],
  logQueriesLongerThan: '60s',
  serviceMonitor: true
});

local sampleRulesCM = {
    apiVersion: 'v1',
    kind: 'ConfigMap',
    metadata: {
      name: 'thanos-ruler-rules',
      namespace: commonConfig.namespace
    },
    data: {
      'thanos-query.yaml': std.toString(tmix.prometheusRules)
    },
  };

local r = useEmptyDir(t.rule(commonConfig {
  replicas: 1,
  serviceMonitor: true,
  queriers: ['dnssrv+_http._tcp.%s.%s.svc.cluster.local' % [q.service.metadata.name, q.service.metadata.namespace]],
  rulesConfig: [
    { name: sampleRulesCM.metadata.name, key: cmKey } for cmKey in std.objectFields(sampleRulesCM.data)
    ],
  volumeClaimTemplate: {},
  reloaderImage: 'jimmidyson/configmap-reload:v0.5.0'
}));

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
    ),
  "thanos-ruler.yaml": std.manifestYamlStream(
    [ r[name] for name in std.objectFields(r) if r[name] != null ] + [sampleRulesCM], quote_keys=false
    )
}
