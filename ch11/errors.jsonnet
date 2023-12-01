local prometheusRuleGroup = {
    name: error "Must provide a name for the Prometheus rule group.",
    rules: []
};

{
    groups: [
        prometheusRuleGroup + {
                name: "node_exporter"
            }
        ],
}
