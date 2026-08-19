output "resource_group_name" {
  description = "Names of the environment resource groups."
  value       = { for environment, resource_group in azurerm_resource_group.this : environment => resource_group.name }
}

output "resource_group_id" {
  description = "Resource IDs of the environment resource groups."
  value       = { for environment, resource_group in azurerm_resource_group.this : environment => resource_group.id }
}

output "aks_name" {
  description = "Names of the environment AKS clusters."
  value       = { for environment, cluster in module.aks : environment => cluster.name }
}

output "aks_resource_group_name" {
  description = "Resource groups containing the environment AKS clusters."
  value       = { for environment, cluster in module.aks : environment => cluster.resource_group_name }
}

output "container_registry_login_server" {
  description = "Login server used by the build pipeline to publish container images."
  value       = azurerm_container_registry.this.login_server
}