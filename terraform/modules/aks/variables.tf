variable "name" {
  description = "Name of the AKS cluster."
  type        = string
}

variable "location" {
  description = "Azure region for the AKS cluster."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group containing the AKS cluster."
  type        = string
}

variable "node_count" {
  description = "Initial number of nodes in the system node pool."
  type        = number
  default     = 1
}

variable "vm_size" {
  description = "VM size for the system node pool."
  type        = string
  default     = "Standard_D2s_v7"
}

variable "min_count" {
  description = "Minimum number of nodes in the system node pool."
  type        = number
  default     = 1
}

variable "max_count" {
  description = "Maximum number of nodes in the system node pool."
  type        = number
  default     = 3
}

variable "tags" {
  description = "Tags applied to the AKS cluster."
  type        = map(string)
  default     = {}
}
