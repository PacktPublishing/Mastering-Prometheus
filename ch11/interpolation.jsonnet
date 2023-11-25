[
{
    local program = "Jsonnet",
    interpolation: "I am using %s to interpolate this string." % program,
    concatenation: "I am using " + program + " to concatenate this string."
},

{
    local _config = {
        program: "Jsonnet",
        os: "Linux"
    },
    inlineInterpolation: "I am using %(program)s on %(os)s to interpolate this string." % _config,
},
{
    groups: [
        {
            local _config = {matchers: 'service="prometheus",environment="prod"'},
            name: "chapter11",
            rules: [
                {
                    alert: "SSHDown",
                    expr: |||
                        last_over_time(
                            probe_success{service="blackbox_ssh",%(matchers)s}[5m]
                            ) != 1
                    ||| % _config,
                    "for": "5m",
                },
            ]
        }
    ]
}
]
