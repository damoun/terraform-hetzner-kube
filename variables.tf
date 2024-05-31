variable "name" {
  description = "The name of the cluster."
  type        = string
}

variable "hcloud_token" {
  description = "The Hetzner Cloud API token."
  type        = string
  sensitive   = true
}

variable "ssh_public_key" {
  description = "SSH public Key."
  type        = string
}

variable "ssh_private_key" {
  description = "SSH private Key."
  type        = string
  sensitive   = true
}

variable "region" {
  description = "The region where the cluster should be created."
  type        = string

  validation {
    condition     = contains(["eu-central", "eu-east", "us-west"], var.region)
    error_message = "Region must be \"eu-central\", \"eu-east\" or \"us-west\"."
  }
}

variable "control_plane_nodepools" {
  description = "The number of control plane nodes."
  type = list(object({
    name                       = optional(string, "control-plane")
    server_type                = string
    location                   = string
    backups                    = optional(bool)
    labels                     = optional(list(string), [])
    taints                     = optional(list(string), [])
    count                      = optional(number, 1)
    swap_size                  = optional(string, "")
    zram_size                  = optional(string, "")
    kubelet_args               = optional(list(string), ["kube-reserved=cpu=250m,memory=1500Mi,ephemeral-storage=1Gi", "system-reserved=cpu=250m,memory=300Mi"])
    selinux                    = optional(bool, true)
    placement_group_compat_idx = optional(number, 0)
    placement_group            = optional(string, null)
  }))

  validation {
    condition = length(
      [for control_plane_nodepool in var.control_plane_nodepools : control_plane_nodepool.name]
      ) == length(
      distinct(
        [for control_plane_nodepool in var.control_plane_nodepools : control_plane_nodepool.name]
      )
    )
    error_message = "Names in control_plane_nodepools must be unique."
  }
}

variable "agent_nodepools" {
  description = "The number of agent nodes."
  type = list(object({
    name                       = optional(string, "agent")
    server_type                = string
    location                   = string
    backups                    = optional(bool)
    floating_ip                = optional(bool)
    labels                     = optional(list(string), [])
    taints                     = optional(list(string), [])
    longhorn_volume_size       = optional(number)
    swap_size                  = optional(string, "")
    zram_size                  = optional(string, "")
    kubelet_args               = optional(list(string), ["kube-reserved=cpu=50m,memory=300Mi,ephemeral-storage=1Gi", "system-reserved=cpu=250m,memory=300Mi"])
    selinux                    = optional(bool, true)
    placement_group_compat_idx = optional(number, 0)
    placement_group            = optional(string, null)
    count                      = optional(number, 1)
    nodes = optional(map(object({
      server_type                = optional(string)
      location                   = optional(string)
      backups                    = optional(bool)
      floating_ip                = optional(bool)
      labels                     = optional(list(string))
      taints                     = optional(list(string))
      longhorn_volume_size       = optional(number)
      swap_size                  = optional(string, "")
      zram_size                  = optional(string, "")
      kubelet_args               = optional(list(string), ["kube-reserved=cpu=50m,memory=300Mi,ephemeral-storage=1Gi", "system-reserved=cpu=250m,memory=300Mi"])
      selinux                    = optional(bool, true)
      placement_group_compat_idx = optional(number, 0)
      placement_group            = optional(string, null)
      append_index_to_node_name  = optional(bool, true)
    })))
  }))

  validation {
    condition = length(
      [for agent_nodepool in var.agent_nodepools : agent_nodepool.name]
      ) == length(
      distinct(
        [for agent_nodepool in var.agent_nodepools : agent_nodepool.name]
      )
    )
    error_message = "Names in agent_nodepools must be unique."
  }

  validation {
    condition     = alltrue([for agent_nodepool in var.agent_nodepools : (agent_nodepool.count == null) != (agent_nodepool.nodes == null)])
    error_message = "Set either nodes or count per agent_nodepool, not both."
  }

  validation {
    condition = alltrue([for agent_nodepool in var.agent_nodepools :
      alltrue([for agent_key, agent_node in coalesce(agent_nodepool.nodes, {}) : can(tonumber(agent_key)) && tonumber(agent_key) == floor(tonumber(agent_key)) && 0 <= tonumber(agent_key) && tonumber(agent_key) < 154])
    ])
    # 154 because the private ip is derived from tonumber(key) + 101. See private_ipv4 in agents.tf
    error_message = "The key for each individual node in a nodepool must be a stable integer in the range [0, 153] cast as a string."
  }

  validation {
    condition = sum([for agent_nodepool in var.agent_nodepools : length(coalesce(agent_nodepool.nodes, {})) + coalesce(agent_nodepool.count, 0)]) <= 100
    # 154 because the private ip is derived from tonumber(key) + 101. See private_ipv4 in agents.tf
    error_message = "Hetzner does not support networks with more than 100 servers."
  }
}

variable "autoscaler_nodepools" {
  description = "The cluster autoscaler nodepools."
  type = list(object({
    name         = string
    server_type  = string
    location     = string
    min_nodes    = number
    max_nodes    = number
    labels       = optional(map(string), {})
    kubelet_args = optional(list(string), ["kube-reserved=cpu=50m,memory=300Mi,ephemeral-storage=1Gi", "system-reserved=cpu=250m,memory=300Mi"])
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
  }))

  default = []
}

# https://docs.hetzner.com/dns-console/dns/general/recursive-name-servers/
variable "dns_servers" {
  description = "The DNS servers to use."
  type        = list(string)
  default = [
    "185.12.64.1",
    "185.12.64.2",
    "2a01:4ff:ff00::add:1"
  ]
}

variable "firewall_kube_api_source" {
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
  description = "Source networks that have Kube API access to the servers."
}

variable "firewall_ssh_source" {
  type        = list(string)
  default     = ["0.0.0.0/0", "::/0"]
  description = "Source networks that have SSH access to the servers."
}

variable "etcd_s3_backup" {
  description = "Etcd cluster state backup to S3 storage"
  type        = map(any)
  sensitive   = true
  default     = {}
}
