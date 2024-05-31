provider "hcloud" {
  token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
}

module "hz-eu" {
  source = "damoun/hetzner/kube"

  providers = {
    hcloud = hcloud
  }

  ssh_public_key  = file("~/.ssh/id_rsa.pub")
  ssh_private_key = file("~/.ssh/id_rsa")

  region = "eu-central"

  control_plane_nodepools = [{
    name        = "control-plane-fsn1"
    server_type = "cax11"
    location    = "fsn1"
    labels      = []
    taints      = []
    count       = 1
    }, {
    name        = "control-plane-nbg1"
    server_type = "cax11"
    location    = "nbg1"
    labels      = []
    taints      = []
    count       = 1
    }, {
    name        = "control-plane-hel1"
    server_type = "cax11"
    location    = "hel1"
    labels      = []
    taints      = []
    count       = 1
  }]
}
