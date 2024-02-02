{
    _config:: {
        matchers: 'service="prometheus",environment="prod"',
        forDuration: '5m'
        },
    groups: [
        {
            name: "chapter11",
            rules: [
                {
                    alert: "SSHDown",
                    expr: |||
                        last_over_time(
                            probe_success{job="blackbox_ssh",%(matchers)s}[5m]
                            ) != 1
                    ||| % $._config,
                    "for": $._config.forDuration,
                },
            ]
        }
    ]
}
