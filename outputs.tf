output "kubeconfig" {
  value     = module.kube.kubeconfig
  description = "Value of the kubeconfig"
  sensitive = true
}
