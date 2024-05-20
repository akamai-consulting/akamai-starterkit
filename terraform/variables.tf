variable "edgerc_path" {
  type    = string
  default = "~/.edgerc"
}

variable "deployment_name" {
  description = "Name of the deployment. Should correspond to the branch or PR."
  type  = string
}

variable "network" {
  description = "String for the Akamai network being used for deployment.  Stage or Prod."
  type        = string
  default     = "STAGING"
}

variable "contract_id" {
  type    = string
}

variable "group_id" {
  type    = string
}
variable "base_url" {
  description = "Base URL to use for the environments."
  type        = string
  default = "edgejourney.dev"
}

# see here: https://techdocs.akamai.com/terraform/docs/common-identifiers#product-ids
variable "product_id"{
  description = "Product ID for the product that this deployment is part of."
  type    = string
  default = "prd_SPM"
}

variable "config_section" {
  type    = string
  default = "default"
}

locals {
  hostnames = [format("%s.%s", var.deployment_name, var.base_url)]
}
