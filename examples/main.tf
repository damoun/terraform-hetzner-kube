module "hz-eu" {
  source = "../"

  hcloud_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

  name = "hz-eu"

  ssh_public_key  = file("~/.ssh/id_ed25519.pub")
  ssh_private_key = file("~/.ssh/id_ed25519")

  region = "eu-central"

  control_plane_nodepools = [{
    server_type = "cax11"
    location    = "fsn1"
  }]

  agent_nodepools = [{
    server_type = "cax11"
    location    = "fsn1"
  }]
}
