terraform {
  required_providers {
    akamai = {
      source  = "akamai/akamai"
      version = "6.1"
    }
  }

  backend "s3" {
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true
    key                         = "state"
    workspace_key_prefix        = "terraform/local/workspace"
    region                      = "us-east-1"
    endpoint                    = "https://us-iad-1.linodeobjects.com"
  }

  required_version = ">= 1.0"
}

provider "akamai" {
  edgerc         = var.edgerc_path
  config_section = var.config_section
}
