output "name" {
  description = "Name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.name
}

output "resource_group_name" {
  description = "Resource group containing the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.resource_group_name
}

output "kubelet_identity_object_id" {
  description = "Object ID used by the AKS kubelet identity for Azure resource access."
  value       = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
}
