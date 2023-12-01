local validation(rule) =
    if std.type(rule) == "object" then rule else error "Rule must be an object";

local prometheusRuleGroup = {
    name: error "Must provide a name for the Prometheus rule group.",
    rules:: [],
    goodRules: std.map(validation, self.rules),
    assert std.type(self.rules) == "array" : "The rules field must be an array",
    assert std.length(self.rules) > 0 : "Why are you trying to define a rule group without any rules?",
};

{
    groups: [
        prometheusRuleGroup + {
                name: "node_exporter",
                rules: [
                    {
                        alert: "ScrapeJobDown",
                        expr: "up != 1"
                    },
                    "foo"
                ]
            }
        ],
}
