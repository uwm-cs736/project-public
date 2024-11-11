# module "ingress_nginx" {
#   source = "./ingress_nginx"
# }

module "kubernetes_dashboard" {
  source = "./kubernetes_dashboard"
}

module "prometheus" {
  source = "./prometheus"
}