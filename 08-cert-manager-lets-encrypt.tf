resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.8.0"

  namespace        = "cert-manager"
  create_namespace = true
  force_update = true

  #values = [file("cert-manager-values.yaml")]

  set {
    name  = "installCRDs"
    value = "true"
  }

  depends_on = [
  helm_release.ingress_nginx,
  ]
  #  module.aks-cluster,
  #  module.aks-cluster-required-config,

}

# After Cert Manager is installed, then install the ClusterIssuer. 
# https://cert-manager.io/docs/configuration/acme/
#
# TODO: Note: Using kubernetes_manifest requires a 2nd apply, which is not ideal. See these two issues:
# https://stackoverflow.com/questions/69765121/how-to-avoid-clusterissuer-dependency-on-helm-cert-manager-crds-in-terraform-pla
# Keeping this block here for reference, but see the kubectl_manifest block below
# for a better solution that doesn't require a 2nd apply.

# TODO - add this to its own file?
/*resource "kubernetes_manifest" "clusterissuer_letsencrypt_prod" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt-prod"
    }
    "spec" = {
      "acme" = {
        # TODO change this email address to a variable
        "email" = "bpresley@theimaginegroup.com"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-prod"
        }
        # TODO change this to a variable, enum between production and staging certificates
        "server" = "https://acme-v02.api.letsencrypt.org/directory"
        "solvers" = [
          {
            "http01" = {
              "ingress" = {
                "class" = "nginx"
              }
            }
          },
        ]
      }
    }
  }
  depends_on = [
    module.aks-cluster,
    module.aks-cluster-required-config,
    helm_release.cert-manager,
  ]
}*/

# See:
# https://github.com/gavinbunney/terraform-provider-kubectl
# 
resource "kubectl_manifest" "clusterissuer_letsencrypt_prod" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    # You must replace this email address with your own.
    # Let's Encrypt will use this to contact you about expiring
    # certificates, and issues related to your account.
    email: user@example.com
    server: https://acme-staging-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      # Secret resource that will be used to store the account's private key.
      name: letsencrypt-prod-key
    # Add a single challenge solver, HTTP01 using nginx
    solvers:
    - http01:
        ingress:
          class: nginx
YAML
}