module "kube" {
  source  = "kube-hetzner/kube-hetzner/hcloud"
  version = "2.14.0"

  hcloud_token = hcloud.hcloud_token
  providers = {
    hcloud = hcloud
  }

  ssh_public_key  = var.ssh_public_key
  ssh_private_key = var.ssh_private_key

  network_region = var.region

  control_plane_nodepools = var.control_plane_nodepools
  agent_nodepools         = var.agent_nodepools
  autoscaler_nodepools    = var.autoscaler_nodepools

  ingress_controller = "none"

  enable_klipper_metal_lb = "true"
  enable_csi_driver_smb   = true

  allow_scheduling_on_control_plane = true

  cluster_name = var.name

  firewall_kube_api_source = var.firewall_kube_api_source
  firewall_ssh_source      = var.firewall_ssh_source

  cni_plugin = "cilium"

  dns_servers = var.dns_servers

  etcd_s3_backup = var.etcd_s3_backup

  create_kubeconfig    = false
  create_kustomization = false
}
