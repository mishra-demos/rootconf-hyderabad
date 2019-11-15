resource "kubernetes_deployment" "jira" {
  metadata {
    name = "jira"
    labels = {
      app = "jira"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "jira"
      }
    }

    template {
      metadata {
        labels = {
          app = "jira"
        }
      }

      spec {
        container {
          image = "anubhavmishra/jira-on-docker"
          name  = "jira"
        }
      }
    }
  }
}

resource "kubernetes_service" "jira-service" {
  metadata {
    name = "jira"
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "jira"
    }

    port {
      name        = "jira-port"
      port        = "80"
      target_port = "8080"
      protocol    = "TCP"
    }
  }
}