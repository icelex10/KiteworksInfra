variable "location" {
  description = "Azure region for the environment resource groups."
  type        = string
  default     = "centralus"
}

variable "aks_node_count" {
  type    = number
  default = 1
}

variable "aks_vm_size" {
  description = "VM size for the AKS system node pools."
  type        = string
  default     = "Standard_B2s"
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

variable "acr_push_principal_object_id" {
  description = "Optional object ID of the build identity allowed to push images to ACR."
  type        = string
  default     = null
  nullable    = true
}

