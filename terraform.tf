terraform {
  required_version = ">= 1.8.4"
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "1.47.0"
    }
  }
}
