terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.38"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.8"
    }
  }
}


provider "kubernetes" {
  config_paths = ["/Users/kirill/.kube/docluster"]
}

provider "helm" {
  kubernetes {
    config_paths = ["/Users/kirill/.kube/docluster"]
  }
}

