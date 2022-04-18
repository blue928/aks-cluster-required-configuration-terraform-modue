variable "cluster_production_ns" {
  type    = string
  default = "production-ns"
}

variable "storage_class_cluster_location" {
  type        = string
  description = "The cluster's geolocation"
}

variable "lb_public_ip" {
  type        = string
  description = "The public IP address of the load balancer"
}