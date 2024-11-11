resource "kubernetes_service_account" "kubernetes-dashboard-admin" {
  depends_on = [helm_release.kubernetes_dashboard]
  metadata {
    name      = "kubernetes-dashboard-admin"
    namespace = "kubernetes-dashboard"
  }
}

resource "kubernetes_cluster_role_binding" "kubernetes-dashboard-admin" {
  depends_on = [helm_release.kubernetes_dashboard]
  metadata {
    name = "kubernetes-dashboard-admin"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = "kubernetes-dashboard-admin"
    namespace = "kubernetes-dashboard"
  }

}

resource "kubernetes_secret" "kubernetes-dashboard-admin" {
  depends_on = [helm_release.kubernetes_dashboard]
  metadata {
    name      = "kubernetes-dashboard-admin"
    namespace = "kubernetes-dashboard"
    annotations = {
      "kubernetes.io/service-account.name" = "kubernetes-dashboard-admin"
    }
  }
  type = "kubernetes.io/service-account-token"
}