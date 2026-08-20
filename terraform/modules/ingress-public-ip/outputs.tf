output "id" {
  description = "Resource ID of the ingress public IP."
  value       = azurerm_public_ip.this.id
}

output "ip_address" {
  description = "Static IPv4 address assigned to the ingress public IP."
  value       = azurerm_public_ip.this.ip_address
}

output "fqdn" {
  description = "Azure-provided DNS name assigned to the ingress public IP."
  value       = azurerm_public_ip.this.fqdn
}
