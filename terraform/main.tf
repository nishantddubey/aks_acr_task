# terraform/main.tf

provider "azurerm" {
  features {}
}

# Resource Group
resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  sku                 = "Basic"
  admin_enabled       = true
}

# Azure Kubernetes Service (AKS) Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aksdns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
  }
}

# AKS Role Assignment to Access ACR
resource "azurerm_kubernetes_cluster_role_assignment" "acr_pull" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  role_definition_id   = data.azurerm_role_definition.acr_pull.id
  principal_id         = azurerm_kubernetes_cluster.aks.kubelet_identity[0].object_id
}

# Data source to fetch built-in ACR role definition
data "azurerm_role_definition" "acr_pull" {
  name = "AcrPull"
}
