<h1 align="center">
  terraform-hetzner-kube
  <br>
</h1>

<h4 align="center">Terraform module to deploy Kubernetes on Hetzner Cloud.</h4>

<p align="center">
  <a href="#requirements">Requirements</a> •
  <a href="#example">Example</a> •
  <a href="#providers">Providers</a> •
  <a href="#modules">Modules</a> •
  <a href="#inputs">Inputs</a> •
  <a href="#Outputs">Outputs</a> •
  <a href="#resources">Resources</a> •
</p>

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.4 |
| <a name="requirement_hcloud"></a> [hcloud](#requirement\_hcloud) | 1.48.0 |

## Example

```hcl
module "hz-eu" {
  source = "damoun/kube/hetzner"

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
```

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kube"></a> [kube](#module\_kube) | kube-hetzner/kube-hetzner/hcloud | 2.14.4 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_nodepools"></a> [agent\_nodepools](#input\_agent\_nodepools) | The number of agent nodes. | <pre>list(object({<br>    name                       = optional(string, "agent")<br>    server_type                = string<br>    location                   = string<br>    backups                    = optional(bool)<br>    floating_ip                = optional(bool)<br>    labels                     = optional(list(string), [])<br>    taints                     = optional(list(string), [])<br>    longhorn_volume_size       = optional(number)<br>    swap_size                  = optional(string, "")<br>    zram_size                  = optional(string, "")<br>    kubelet_args               = optional(list(string), ["kube-reserved=cpu=50m,memory=300Mi,ephemeral-storage=1Gi", "system-reserved=cpu=250m,memory=300Mi"])<br>    selinux                    = optional(bool, true)<br>    placement_group_compat_idx = optional(number, 0)<br>    placement_group            = optional(string, null)<br>    count                      = optional(number, 1)<br>    nodes = optional(map(object({<br>      server_type                = optional(string)<br>      location                   = optional(string)<br>      backups                    = optional(bool)<br>      floating_ip                = optional(bool)<br>      labels                     = optional(list(string))<br>      taints                     = optional(list(string))<br>      longhorn_volume_size       = optional(number)<br>      swap_size                  = optional(string, "")<br>      zram_size                  = optional(string, "")<br>      kubelet_args               = optional(list(string), ["kube-reserved=cpu=50m,memory=300Mi,ephemeral-storage=1Gi", "system-reserved=cpu=250m,memory=300Mi"])<br>      selinux                    = optional(bool, true)<br>      placement_group_compat_idx = optional(number, 0)<br>      placement_group            = optional(string, null)<br>      append_index_to_node_name  = optional(bool, true)<br>    })))<br>  }))</pre> | n/a | yes |
| <a name="input_autoscaler_nodepools"></a> [autoscaler\_nodepools](#input\_autoscaler\_nodepools) | The cluster autoscaler nodepools. | <pre>list(object({<br>    name         = string<br>    server_type  = string<br>    location     = string<br>    min_nodes    = number<br>    max_nodes    = number<br>    labels       = optional(map(string), {})<br>    kubelet_args = optional(list(string), ["kube-reserved=cpu=50m,memory=300Mi,ephemeral-storage=1Gi", "system-reserved=cpu=250m,memory=300Mi"])<br>    taints = optional(list(object({<br>      key    = string<br>      value  = string<br>      effect = string<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_control_plane_nodepools"></a> [control\_plane\_nodepools](#input\_control\_plane\_nodepools) | The number of control plane nodes. | <pre>list(object({<br>    name                       = optional(string, "control-plane")<br>    server_type                = string<br>    location                   = string<br>    backups                    = optional(bool)<br>    labels                     = optional(list(string), [])<br>    taints                     = optional(list(string), [])<br>    count                      = optional(number, 1)<br>    swap_size                  = optional(string, "")<br>    zram_size                  = optional(string, "")<br>    kubelet_args               = optional(list(string), ["kube-reserved=cpu=250m,memory=1500Mi,ephemeral-storage=1Gi", "system-reserved=cpu=250m,memory=300Mi"])<br>    selinux                    = optional(bool, true)<br>    placement_group_compat_idx = optional(number, 0)<br>    placement_group            = optional(string, null)<br>  }))</pre> | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | The DNS servers to use. | `list(string)` | <pre>[<br>  "185.12.64.1",<br>  "185.12.64.2",<br>  "2a01:4ff:ff00::add:1"<br>]</pre> | no |
| <a name="input_etcd_s3_backup"></a> [etcd\_s3\_backup](#input\_etcd\_s3\_backup) | Etcd cluster state backup to S3 storage | `map(any)` | `{}` | no |
| <a name="input_firewall_kube_api_source"></a> [firewall\_kube\_api\_source](#input\_firewall\_kube\_api\_source) | Source networks that have Kube API access to the servers. | `list(string)` | <pre>[<br>  "0.0.0.0/0",<br>  "::/0"<br>]</pre> | no |
| <a name="input_firewall_ssh_source"></a> [firewall\_ssh\_source](#input\_firewall\_ssh\_source) | Source networks that have SSH access to the servers. | `list(string)` | <pre>[<br>  "0.0.0.0/0",<br>  "::/0"<br>]</pre> | no |
| <a name="input_hcloud_token"></a> [hcloud\_token](#input\_hcloud\_token) | The Hetzner Cloud API token. | `string` | n/a | yes |
| <a name="input_ingress_controller"></a> [ingress\_controller](#input\_ingress\_controller) | Ingress controller to install. Disabled by default. | `string` | `"none"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name of the cluster. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where the cluster should be created. | `string` | n/a | yes |
| <a name="input_ssh_private_key"></a> [ssh\_private\_key](#input\_ssh\_private\_key) | SSH private Key. | `string` | n/a | yes |
| <a name="input_ssh_public_key"></a> [ssh\_public\_key](#input\_ssh\_public\_key) | SSH public Key. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | Value of the kubeconfig |
| <a name="output_ssh_key_id"></a> [ssh\_key\_id](#output\_ssh\_key\_id) | The ID of the SSH key on Hetzner Cloud. |

## Resources

No resources.
<!-- END_TF_DOCS -->