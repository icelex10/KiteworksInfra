output "resource_group_name" {
  description = "Names of the environment resource groups."
  value       = { for environment, resource_group in azurerm_resource_group.this : environment => resource_group.name }
}

output "resource_group_id" {
  description = "Resource IDs of the environment resource groups."
  value       = { for environment, resource_group in azurerm_resource_group.this : environment => resource_group.id }
}