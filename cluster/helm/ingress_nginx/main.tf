# resource "helm_release" "ingress_nginx" {
#   name             = "ingress-nginx"
#   namespace        = "ingress-nginx"
#   create_namespace = true

#   repository = "https://kubernetes.github.io/ingress-nginx"
#   chart      = "ingress-nginx"

#   # docker-desktop
#   # set {
#   #   name  = "controller.service.ports.http"
#   #   value = 30000
#   # }


#   # kind
#   # set {
#   #   name  = "controller.service.type"
#   #   value = "NodePort"
#   # }
#   # set {
#   #   name  = "controller.service.nodePorts.http"
#   #   value = 30000
#   # }

#   # bare metal
# }