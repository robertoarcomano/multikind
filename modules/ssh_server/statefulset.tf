resource "kubernetes_stateful_set_v1" "ssh-server" {
  metadata {
    name      = "ssh-server"
    namespace = "default"
  }
  
  spec {
    service_name = "ssh-server"
    replicas     = var.replicas
    
    selector {
      match_labels = {
        app = "ssh-server"
      }
    }
    
    template {
      metadata {
        labels = {
          app = "ssh-server"
        }
      }
      
      spec {
        container {
          name  = "ubuntu"
          image = "devdotnetorg/openssh-server:ubuntu"
          
          port {
            container_port = 22
          }
        }
      }
    }
  }
}
