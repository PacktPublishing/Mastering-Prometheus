###
### pint configuration
### DOCS: https://cloudflare.github.io/pint/
###

prometheus "mastering-prometheus" {
  uri         = "http://localhost:9090"
  timeout     = "1m"
  include     = ["out/rules.yaml"]
  concurrency = 16
  rateLimit   = 100
}

rule {
  # Disallow spaces in label/annotation keys, they're only allowed in values.
  reject ".* +.*" {
    label_keys      = true
    annotation_keys = true
  }

  # Disallow URLs in labels, they should go to annotations (cardinality!)
  reject "https?://.+" {
    label_keys   = true
    label_values = true
  }
}

rule {
  # This block will apply to all alerting rules.
  match {
    kind = "alerting"
  }

  # Each alert must have a 'description annotation on every alert.
  annotation "description" {
    severity = "bug" # `bug` severity is like error.. can be bug/warning/info
    required = true
  }

  # Each alert must have a 'severity' annotation that's either 'critical', 'warning', 'info'.
  label "severity" {
    severity = "bug"
    value    = "(critical|warning|info)"
    required = true
  }
}
