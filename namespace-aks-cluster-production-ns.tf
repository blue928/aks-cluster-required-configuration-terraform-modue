resource "kubernetes_namespace_v1" "production_ns" {
  metadata {
    annotations = {}
    labels      = {}
    name        = var.cluster_production_ns
  }
}