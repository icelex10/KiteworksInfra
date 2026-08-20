locals {
  all_environments = {
    dev = {
      name = "rg-kiteworks-dev"
    }
    staging = {
      name = "rg-kiteworks-staging"
    }
    prod = {
      name = "rg-kiteworks-prod"
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

resource "azurerm_resource_group" "this" {
  for_each = local.environments

  name     = each.value.name
  location = var.location

  tags = {
    environment = each.key
    managed_by  = "terraform"
    project     = "kiteworks"
  }
}

module "aks" {
  for_each = local.environments

  source              = "./modules/aks"
  name                = "aks-kiteworks-${each.key}"
  location            = var.location
  resource_group_name = azurerm_resource_group.this[each.key].name
  node_count          = var.aks_node_count
  vm_size             = var.aks_vm_size

  tags = {
    environment = each.key
    managed_by  = "terraform"
    project     = "kiteworks"
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


