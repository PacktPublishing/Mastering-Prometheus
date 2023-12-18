###
### pint configuration
### DOCS: https://cloudflare.github.io/pint/
###

prometheus "mastering-prometheus" {
  uri         = "http://localhost:9090"
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

  # Each alert must have a 'summary' annotation.
  # Must begin with a capital letter, end with a period, and *not* contain templated values.
  annotation "summary" {
    severity = "bug" # `bug` severity is like error.. can be bug/warning/info
    required = true
    value = "[A-Z][^{.!?]+.\\."
  }
  
  # Each alert must have a 'description' annotation.
  # Must begin with a capital letter, end with a period, and include at least one templated value.
  annotation "description" {
    severity = "bug" 
    required = true
    value = "[A-Z].+\\{\\{.*\\}\\}.*\\."
  }

  # Each alert must have a 'severity' annotation that's either 'critical', 'warning', 'info'.
  label "severity" {
    severity = "bug"
    value    = "(critical|warning|info)"
    required = true
  }
}
