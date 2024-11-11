provider "kubernetes" {
  config_path = "${path.module}/kubeconfig/${var.config_name}.yml"
}

provider "helm" {
  kubernetes {
    config_path = "${path.module}/kubeconfig/${var.config_name}.yml"
  }
}

provider "kubectl" {
  config_path = "${path.module}/kubeconfig/${var.config_name}.yml"
}


module "kubernetes" {
  source = "./kubernetes"
}

module "helm" {
  source = "./helm"
}

module "kubectl" {
  source = "./kubectl"
}