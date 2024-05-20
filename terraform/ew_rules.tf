# This cont
data "akamai_property_rules_builder" "ew-routing-rule" {
  depends_on    = [akamai_edgeworkers_activation.my_edgeworker_activation]
  rules_v2024_02_12 {
    name                  =  var.deployment_name
    criteria_must_satisfy = "all"
    criterion {
      path {
        match_case_sensitive = false
        match_operator       = "MATCHES_ONE_OF"
        normalize            = false
        values               = [format("/%s", var.deployment_name)]
      }
    }
    behavior {
      edge_worker {
        create_edge_worker  = ""
        edge_worker_id      = akamai_edgeworker.my_edgeworker.id
        enabled             = true
        m_pulse             = false
        m_pulse_information = ""
        resource_tier       = ""
      }
    }
  }
}

