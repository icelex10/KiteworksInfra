variable "location" {
  description = "Default Azure region for shared platform resources and environments without an override."
  type        = string
  default     = "centralus"
}

variable "environment_locations" {
  description = "Azure region for each AKS environment and its ingress public IP."
  type        = map(string)
  default = {
    dev     = "centralus"
    staging = "eastus"
    prod    = "eastus2"
  }
}

variable "deploy_environments" {
  description = "Which environments to create in this apply."
  type        = list(string)
  default     = ["dev", "staging", "prod"]
}

variable "aks_node_count" {
  type    = number
  default = 1
}

variable "aks_vm_size" {
  description = "VM size for the AKS system node pools."
  type        = string
  default     = "Standard_D2s_v7"
}

variable "container_registry_name" {
  description = "Globally unique Azure Container Registry name."
  type        = string
  default     = "acrkiteworkstestapp1"
}

variable "container_registry_resource_group_name" {
  description = "Resource group containing the shared Azure Container Registry."
  type        = string
  default     = "rg-kiteworkstest-platform"
}

variable "ingress_dns_prefix" {
  description = "Globally unique prefix for Azure-provided ingress DNS names."
  type        = string
  default     = "kiteworkstest"
}

variable "acr_push_principal_object_id" {
  description = "Optional object ID of the build identity allowed to push images to ACR."
  type        = string
  default     = null
  nullable    = true
}

