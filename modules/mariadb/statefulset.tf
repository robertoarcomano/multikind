resource "kubernetes_stateful_set_v1" "mariadb" {
  metadata {
    name      = "mariadb"
    namespace = "default"
  }
  
  spec {
    service_name = "mariadb"
    replicas     = var.mariadb_replicas
    
    selector {
      match_labels = {
        app = "mariadb"
      }
    }
    
    template {
      metadata {
        labels = {
          app = "mariadb"
        }
      }
      
      spec {
        container {
          name  = "mariadb"
          image = "mariadb"
          
          port {
            container_port = 3306
          }

          env {
            name = "MARIADB_ROOT_PASSWORD"
            value_from {
              secret_key_ref {
                name = kubernetes_secret.mariadb.metadata[0].name
                key  = "mariadb_root_password"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "mariadb_nodeport" {
  metadata {
    name      = "mariadb-nodeport"
    namespace = "default"
  }
  
  spec {
    type = "NodePort"
    
    port {
      port       = 3306
      target_port = 3306
      node_port  = 30002
      protocol   = "TCP"
      name       = "mariadb"
    }
    
    selector = {
      app = "mariadb"
    }
  }
  
  depends_on = [kubernetes_stateful_set_v1.mariadb]
}