# resource "kubernetes_service" "svc_lb" {
#   depends_on = [helm_release.app]
#   metadata {
#     name      = "${helm_release.app.name}-lb"
#     namespace = helm_release.app.namespace
#   }
#   spec {
#     selector = {
#       "app.kubernetes.io/instance" = "prometheus"
#       "app.kubernetes.io/name" = "grafana"
#     }
#     port {
#       node_port   = 30011
#       port        = 3000
#       target_port = 3000
#     }

#     type = "NodePort"
#   }
# }