resource "akamai_property" "my-property" {
  name        = var.deployment_name
  contract_id = var.contract_id
  group_id    = var.group_id
  product_id  = var.product_id
  dynamic hostnames {
    for_each = local.hostnames
    content {
      cname_type             = "EDGE_HOSTNAME"
      cname_from             = hostnames.value
      # TODO will this work?  Skeptical.  Might need to revisit this.
      cname_to               = format("%s.edgekey.net", hostnames.value)
      cert_provisioning_type = "DEFAULT"
    }
  }
  rule_format = data.akamai_property_rules_builder.my-property_rule_default.rule_format
  rules       = data.akamai_property_rules_builder.my-property_rule_default.json
}

# NOTE: Be careful when removing this resource as you can disable traffic
resource "akamai_property_activation" "my-property-activation" {
  property_id                    = akamai_property.my-property.id
  contact                        = ["aweingar@akamai.com"]
  version                        = akamai_property.my-property.latest_version
  network                        = var.network
  auto_acknowledge_rule_warnings = true
}

output "my-property" {
  value = akamai_property.my-property
}

output "activation" {
  value = akamai_property_activation.my-property-activation
}

output "akamai_property_id" {
  value = akamai_property.my-property.id
  description = "The ID of the Akamai property"
}

output "akamai_dns_record_id" {
  value = akamai_dns_record.my_dns_validation.id
  description = "The ID of the Akamai property"
}
