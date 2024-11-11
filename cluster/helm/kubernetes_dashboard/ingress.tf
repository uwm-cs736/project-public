# resource "kubernetes_ingress_v1" "kubernetes_dashboard" {
#   depends_on = [helm_release.kubernetes_dashboard]
#   metadata {
#     name      = "kubernetes-dashboard"
#     namespace = "kubernetes-dashboard"
#   }

#   spec {
#     ingress_class_name = "nginx"
#     rule {
#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"
#           backend {
#             service {
#               name = "kubernetes-dashboard-kong-proxy"
#               port {
#                 number = 443
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }


resource "kubernetes_service" "kubernetes_dashboard_lb" {
  depends_on = [helm_release.kubernetes_dashboard]
  metadata {
    name      = "${helm_release.kubernetes_dashboard.name}-lb"
    namespace = helm_release.kubernetes_dashboard.namespace
  }
  spec {
    selector = {
      app = "kubernetes-dashboard-kong"
    }
    port {
      node_port   = 30010
      port        = 8443
      target_port = 8443
    }

    type = "NodePort"
  }
}