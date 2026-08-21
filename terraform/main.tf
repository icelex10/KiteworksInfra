locals {
  all_environments = {
    dev = {
      name     = "rg-kiteworks-dev"
      location = lookup(var.environment_locations, "dev", var.location)
    }
    staging = {
      name     = "rg-kiteworks-staging"
      location = lookup(var.environment_locations, "staging", var.location)
    }
    prod = {
      name     = "rg-kiteworks-prod"
      location = lookup(var.environment_locations, "prod", var.location)
    }
  }

  environments = {
    for env, cfg in local.all_environments : env => cfg if contains(var.deploy_environments, env)
  }
}

moved {
  from = azurerm_kubernetes_cluster.this
  to   = module.aks["dev"].azurerm_kubernetes_cluster.this
}

moved {
  from = azurerm_public_ip.ingress["dev"]
  to   = module.ingress_public_ip["dev"].azurerm_public_ip.this
}

moved {
  from = azurerm_public_ip.ingress["staging"]
  to   = module.ingress_public_ip["staging"].azurerm_public_ip.this
}

moved {
  from = azurerm_public_ip.ingress["prod"]
  to   = module.ingress_public_ip["prod"].azurerm_public_ip.this
}

resource "azurerm_resource_group" "this" {
  for_each = local.environments

  name     = each.value.name
  location = each.value.location

  tags = {
    environment = each.key
    managed_by  = "terraform"
    project     = "kiteworks"
  }
}

module "aks" {
  for_each = local.environments

  source                      = "./modules/aks"
  name                        = "aks-kiteworks-${each.key}"
  location                    = each.value.location
  resource_group_name         = azurerm_resource_group.this[each.key].name
  node_count                  = var.aks_node_count
  vm_size                     = var.aks_vm_size
  temporary_name_for_rotation = "sysrotate"

  tags = {
    environment = each.key
    managed_by  = "terraform"
    project     = "kiteworks"
  }
}

module "ingress_public_ip" {
  for_each = local.environments

  source              = "./modules/ingress-public-ip"
  name                = "pip-kiteworks-ingress-${each.key}"
  location            = each.value.location
  resource_group_name = module.aks[each.key].node_resource_group
  domain_name_label   = "${var.ingress_dns_prefix}-${each.key}"

  tags = {
    environment = each.key
    managed_by  = "terraform"
    project     = "kiteworks"
    purpose     = "nginx-ingress"
  }
}

resource "azurerm_container_registry" "this" {
  name                          = var.container_registry_name
  resource_group_name           = var.container_registry_resource_group_name
  location                      = var.location
  sku                           = "Basic"
  admin_enabled                 = false
  public_network_access_enabled = true

  identity {
    type = "SystemAssigned"
  }

  lifecycle {
    prevent_destroy = true
  }

  tags = {
    managed_by = "terraform"
    project    = "kiteworks"
    purpose    = "container-images"
  }
}

resource "azurerm_role_assignment" "aks_acr_pull" {
  for_each = module.aks

  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPull"
  principal_id         = each.value.kubelet_identity_object_id
}

resource "azurerm_role_assignment" "build_acr_push" {
  count = var.acr_push_principal_object_id == null ? 0 : 1

  scope                = azurerm_container_registry.this.id
  role_definition_name = "AcrPush"
  principal_id         = var.acr_push_principal_object_id
}


