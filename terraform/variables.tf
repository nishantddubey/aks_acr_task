# terraform/variables.tf

variable "location" {
  default = "East US"
}

variable "resource_group_name" {
  default = "aks-acr-resource-group"
}

variable "acr_name" {
  default = "myacrregistry12345"
}

variable "aks_cluster_name" {
  default = "my-aks-cluster"
}
