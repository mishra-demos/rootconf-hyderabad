resource "random_id" "atlantis_webhook" {
  byte_length = "64"
}

resource "kubernetes_secret" "tls" {
  metadata {
    name = "tls"
  }

  data = {
    "tls.crt" = "${tls_locally_signed_cert.cert.cert_pem}"
    "tls.key" = "${tls_private_key.key.private_key_pem}"
  }
}

resource "kubernetes_pod" "pod" {
  metadata {
    name = "atlantis"

    labels = {
      app = "atlantis"
    }
  }

  spec {
    volume {
      name = "tls"

      secret {
        secret_name = "tls"
      }
    }

    container {
      name  = "atlantis"
      image = var.atlantis_container
      args  = ["server"]

      port {
        name           = "atlantis"
        container_port = "4141"
        protocol       = "TCP"
      }

      env {
        name  = "ATLANTIS_LOG_LEVEL"
        value = "debug"
      }

      env {
        name  = "ATLANTIS_PORT"
        value = "4141"
      }

      env {
        name  = "ATLANTIS_ATLANTIS_URL"
        value = "https://${google_compute_address.atlantis.address}"
      }

      env {
        name  = "ATLANTIS_GH_USER"
        value = var.atlantis_github_user
      }

      env {
        name  = "ATLANTIS_GH_TOKEN"
        value = var.atlantis_github_user_token
      }

      env {
        name  = "ATLANTIS_GH_WEBHOOK_SECRET"
        value = "${random_id.atlantis_webhook.hex}"
      }

      env {
        name  = "ATLANTIS_REPO_WHITELIST"
        value = var.atlantis_repo_whitelist
      }

      env {
        name  = "ATLANTIS_SSL_CERT_FILE"
        value = "/etc/atlantis/tls/tls.crt"
      }

      env {
        name  = "ATLANTIS_SSL_KEY_FILE"
        value = "/etc/atlantis/tls/tls.key"
      }

      env {
        name  = "ATLANTIS_TFE_TOKEN"
        value = var.atlantis_tfe_token
      }

      resources {
        requests {
          cpu    = "500m"
          memory = "512Mi"
        }
      }

      volume_mount {
        name       = "tls"
        mount_path = "/etc/atlantis/tls"
        read_only  = true
      }

      readiness_probe {
        initial_delay_seconds = "5"
        period_seconds        = "10"
        timeout_seconds       = "5"

        http_get {
          path   = "/"
          port   = "4141"
          scheme = "HTTPS"
        }
      }
    }
  }
}

resource "kubernetes_service" "service" {
  metadata {
    name = "atlantis"
  }

  spec {
    type = "LoadBalancer"

    load_balancer_ip = "${google_compute_address.atlantis.address}"

    selector = {
      app = "${kubernetes_pod.pod.metadata.0.labels.app}"
    }

    port {
      name        = "atlantis-port"
      port        = "443"
      target_port = "4141"
      protocol    = "TCP"
    }
  }
}