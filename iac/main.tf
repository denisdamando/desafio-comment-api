resource "kubernetes_namespace" "comentario" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment_v1" "desafio-comment-api" {
  metadata {
    name = "desafio-comment-api"
    namespace = var.namespace
    labels = {
      test = "desafio-comment-api"
    }
  }
  

  spec {
    replicas = 1

    selector {
      match_labels = {
        test = "desafio-comment-api"
      }
    }

    template {
      metadata {
        labels = {
          test = "desafio-comment-api"
        }
      }

      spec {
        container {
          image = "denisdamando/desafio-comment-api:latest"
          name  = "example"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          # liveness_probe {
          #   http_get {
          #     path = "/"
          #     port = 8000

          #     http_header {
          #       name  = "X-Custom-Header"
          #       value = "Awesome"
          #     }
          #   }

          #   initial_delay_seconds = 3
          #   period_seconds        = 3
          # }
        }
      }
    }
  }
}

resource "kubernetes_service" "desafio-comment-api" {
  metadata {
    name = "desafio-comment-api"
    namespace = var.namespace
  }

  spec {
    selector = {
      test = "desafio-comment-api"
    }

    port {
      port        = 8000
      target_port = 8000
    }
  }
}

resource "kubernetes_ingress_v1" "desafio-comment-api" {
  wait_for_load_balancer = false
  metadata {
    name = "desafio-comment-api"
    namespace = var.namespace
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = "desafio-comment-api.${var.environment}"
      http {
        path {
          path = "/*"
          backend {
            service {
              name = "desafio-comment-api"
              port {
                number = 8000
              }
            }
          }
        }
      }
    }
  }
}