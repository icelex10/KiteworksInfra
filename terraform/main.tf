locals {
  environments = {
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