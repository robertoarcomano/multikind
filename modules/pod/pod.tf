resource "kubernetes_pod_v1" "ubuntu_pod" {
  metadata {
    name      = "ubuntu-test-pod"
    namespace = "default"
  }

  spec {
    container {
      name  = "ubuntu"
      image = "ubuntu:22.04"  # Immagine LTS stabile

      command = ["/bin/bash"]
      args    = ["-c", "while true; do echo 'Pod Ubuntu attivo $(date)'; sleep 30; done"]

      resources {
        limits = {
          cpu    = "100m"
          memory = "128Mi"
        }
      }
    }
  }
}
