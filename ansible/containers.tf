resource "kubernetes_stateful_set_v1" "ansibletest" {
  metadata {
    name      = "ansibletest"
    namespace = "default"
  }
  
  spec {
    service_name = "ansibleservice"
    replicas     = 1
    
    selector {
      match_labels = {
        app = "ansibletest"
      }
    }
    
    template {
      metadata {
        labels = {
          app = "ansibletest"
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
