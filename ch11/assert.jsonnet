local prometheusRuleGroup = {
    name: error "Must provide a name for the Prometheus rule group.",
    rules: [],
    assert std.type(self.rules) == "array" : "The rules field must be an array",
    assert std.length(self.rules) > 0 : "Why are you trying to define a rule group without any rules?",
};

{
    groups: [
        prometheusRuleGroup + {
                name: "general",
                rules: [
                    {
                        alert: "ScrapeJobDown",
                        expr: "up != 1"
                    },
                ]
            }
        ],
}
