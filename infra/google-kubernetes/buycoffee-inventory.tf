resource "kubernetes_deployment" "buycoffee-inventory" {
  metadata {
    name = "buycoffee-inventory"
    labels = {
      app = "buycoffee-inventory"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "buycoffee-inventory"
      }
    }

    template {
      metadata {
        labels = {
          app = "buycoffee-inventory"
        }
      }

      spec {
        container {
          image = var.buycoffee_inventory_image
          name  = "buycoffee-inventory"

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = var.buycoffee_inventory_port
            }

            initial_delay_seconds = 2
            period_seconds        = 10
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "buycoffee-inventory-service" {
  metadata {
    name = "buycoffee-inventory"
  }

  spec {
    type = "LoadBalancer"

    load_balancer_ip = "${google_compute_address.buycoffee-inventory.address}"

    selector = {
      app = "buycoffee-inventory"
    }

    port {
      name        = "buycoffee-inventory-port"
      port        = "80"
      target_port = "8081"
      protocol    = "TCP"
    }
  }
}