resource "helm_release" "envoy_gateway" {
  name             = "envoy-gateway"
  namespace        = "envoy-gateway-system"
  create_namespace = true

  repository = "oci://docker.io/envoyproxy"
  chart      = "gateway-helm"

  version = "1.8.3"

  wait    = true
  timeout = 600
}

resource "kubernetes_manifest" "gateway" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"

    metadata = {
      name      = "main"
      namespace = "default"
    }

    spec = {
      gatewayClassName = "eg"

      listeners = [{
        name     = "http"
        protocol = "HTTP"
        port     = 80
      }]
    }
  }

  depends_on = [
    helm_release.envoy_gateway
  ]
}


resource "kubernetes_manifest" "nginx_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"

    metadata = {
      name = "nginx"
    }

    spec = {
      parentRefs = [
        {
          name = kubernetes_manifest.gateway.manifest.metadata.name
        }
      ]

      rules = [
        {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = "/"
              }
            }
          ]

          backendRefs = [
            {
              name = kubernetes_service_v1.nginx.metadata[0].name
              port = 80
            }
          ]
        }
      ]
    }
  }

  depends_on = [
    kubernetes_service_v1.nginx,
    kubernetes_manifest.gateway
  ]
}
