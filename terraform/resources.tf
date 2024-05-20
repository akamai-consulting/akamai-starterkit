resource "null_resource" "prepare_ew_bundle_tgz" {
  provisioner "local-exec" {
    command = "cd ../edge-worker && tar -czvf ../terraform/edge-worker-bundle.tgz *"
  }
}



resource "akamai_edgeworker" "my_edgeworker" {
  depends_on       = [null_resource.prepare_ew_bundle_tgz]
  group_id         = var.group_id
  name             = var.deployment_name
  local_bundle     = "edge-worker-bundle.tgz"
  resource_tier_id = 100
}

resource "akamai_edgeworkers_activation" "my_edgeworker_activation" {
  depends_on    = [akamai_edgeworker.my_edgeworker]
  edgeworker_id = akamai_edgeworker.my_edgeworker.id
  network       = var.network
  version       = akamai_edgeworker.my_edgeworker.version
}
