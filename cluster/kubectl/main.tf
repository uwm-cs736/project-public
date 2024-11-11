data "kubectl_file_documents" "wrk" {
  content = file("${path.module}/wrk/workload.yaml")
}

resource "kubectl_manifest" "wrk" {
  for_each  = data.kubectl_file_documents.wrk.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "knative_operator" {
  content = file("${path.module}/knative/operator.yaml")
}

resource "kubectl_manifest" "knative_operator" {
  for_each  = data.kubectl_file_documents.knative_operator.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "knative_serving" {
  content    = file("${path.module}/knative/serving.yaml")
}

resource "kubectl_manifest" "knative_serving" {
  depends_on = [kubectl_manifest.knative_operator]
  for_each  = data.kubectl_file_documents.knative_serving.manifests
  yaml_body = each.value
}

data "kubectl_file_documents" "knative_serving_dns" {
  content = file("${path.module}/knative/serving-default-domain.yaml")
}

resource "kubectl_manifest" "knative_serving_dns" {
  depends_on = [kubectl_manifest.knative_serving]
  for_each   = data.kubectl_file_documents.knative_serving_dns.manifests
  yaml_body  = each.value
}


data "kubectl_file_documents" "nettool" {
  content = file("${path.module}/nettool/workload.yaml")
}

resource "kubectl_manifest" "nettool" {
  for_each  = data.kubectl_file_documents.nettool.manifests
  yaml_body = each.value
}