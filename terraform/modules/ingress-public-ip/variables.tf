variable "name" {
  description = "Name of the ingress public IP resource."
  type        = string
}

variable "location" {
  description = "Azure region for the public IP resource."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the public IP resource."
  type        = string
}

variable "domain_name_label" {
  description = "Globally unique Azure-provided DNS label."
  type        = string
}

variable "tags" {
  description = "Tags applied to the public IP resource."
  type        = map(string)
  default     = {}
}
