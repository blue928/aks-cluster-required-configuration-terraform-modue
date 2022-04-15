
# ---------------------------------------------------------------------------------------------------------------------
# AKS CLUSTER REQUIRED CONFIGURATION
# After the AKS Cluster is created this default configuration must be applied.
# The resources created are:
#  - Storage:
#    - storage-aks-azure-file-share-storage-class.tf 
#  - Namespace
#    - namespace-aks-cluster-production-ns.tf 
# todo: add the others
# ---------------------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    kubectl = {
      source = "gavinbunney/kubectl"
      #version = ">= 1.7.0"
    }
  }
}