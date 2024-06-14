// Part 1. Create Certificate Enrollment
// Part 2. Create new DNS record and deploy it to staging and prod
// Part 3. Create new Property so that I get the edge-key domain for it
# Get Akamai property hostnames status for challenges for Secure by Default
data "akamai_property_hostnames" "my_hostnames" {
  depends_on = [akamai_property_activation.my-property-activation]
  contract_id = var.contract_id
  group_id    = var.group_id
  property_id = akamai_property.my-property.id
}

resource "akamai_dns_record" "my_record_type_cname" {
    count      = length(local.hostnames)
    zone       = var.base_url
    name       = local.hostnames[count.index]
    recordtype = "CNAME"
    ttl        = 1800
    target     = [format("%s.edgekey-staging.net", local.hostnames[count.index])]
}

# Create a map with the same length as dns_hostnames, otherwise if the resource creation depends on data.akamai_property_hostnames TF can't know how many resources it needs to create before the apply and fails.
locals {
  flattened_hostnames = flatten([
    for idx, hostname in data.akamai_property_hostnames.my_hostnames.hostnames : [
      for cert in hostname.cert_status : {
        target = cert.target
        hostname = cert.hostname
      }
    ]
  ])
}

resource "akamai_dns_record" "my_dns_validation" {
  count      = length(local.hostnames)
  zone       = var.base_url
  recordtype = "CNAME"
  ttl        = 60
  target     = [local.flattened_hostnames[count.index].target]
  name       = local.flattened_hostnames[count.index].hostname
}

output "akamai_dns_record_ids" {
  value = { for idx, dns_record in akamai_dns_record.my_dns_validation : idx => dns_record.id }
  description = "The IDs of DNS records"
}

output "akamai_property_hostname_ids" {
  value = data.akamai_property_hostnames.my_hostnames.hostnames
  description = "The list of hostnames for the Akamai property"
}