resource "azurerm_public_ip" "lb_public_ip" {
  name = var.lb_public_ip_name

  # This is the name of the extra NODE resource group Azure automatically creates
  # for cluster resources.
  resource_group_name = azurerm_kubernetes_cluster.k8s.node_resource_group
  location            = azurerm_kubernetes_cluster.k8s.location
  allocation_method   = var.lb_public_ip_allocation_type
  sku                 = "Standard"

  tags = {
    environment = var.environment
  }

  #depends_on = [
  # azurerm_kubernetes_cluster
  #]
}