{
    groups: [
        {
            local matchers = 'service="prometheus",environment="prod"',
            name: "chapter11",
            rules: [
                {
                    alert: "SSHDown",
                    expr: 'last_over_time(probe_success{service="blackbox_ssh",%s}[5m]) != 1' % matchers,
                    "for": "5m",
                },
                {
                    alert: "ICMPDown",
                    expr: 'last_over_time(probe_success{service="blackbox_icmp",%s}[5m]) != 1' % matchers, 
                    "for": "5m",
                }
            ]
        }
    ]
}
