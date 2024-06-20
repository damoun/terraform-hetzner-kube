output "kubeconfig" {
  value       = module.kube.kubeconfig
  description = "Value of the kubeconfig"
  sensitive   = true
}

output "ssh_key_id" {
  value       = module.kube.ssh_key_id
  description = "The ID of the SSH key on Hetzner Cloud."
}
