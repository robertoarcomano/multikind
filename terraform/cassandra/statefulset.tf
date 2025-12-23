resource "kubernetes_stateful_set_v1" "cassandra" {
  metadata {
    name      = "cassandra"
    namespace = "default"
  }
  
  spec {
    service_name = "cassandra"
    replicas     = 1
    
    selector {
      match_labels = {
        app = "cassandra"
      }
    }
    
    template {
      metadata {
        labels = {
          app = "cassandra"
        }
      }
      
      spec {
        container {
          name  = "cassandra"
          image = "cassandra:latest"
          
          port {
            container_port = 9042
          }
          
          env {
            name  = "MAX_HEAP_SIZE"
            value = "10G"
          }
          env {
            name  = "CASSANDRA_CLUSTER_NAME"
            value = "CassandraCluster"
          }
          env {
            name  = "CASSANDRA_DC"
            value = "DC1"
          }
          env {
            name  = "CASSANDRA_RACK"
            value = "Rack1"
          }
          env {
            name  = "POD_NAME"
            value_from {
              field_ref {
                field_path = "metadata.name"
              }
            }
          }
          env {
            name  = "POD_IP"
            value_from {
              field_ref {
                field_path = "status.podIP"
              }
            }
          }
          env {
            name  = "POD_NAMESPACE"
            value_from {
              field_ref {
                field_path = "metadata.namespace"
              }
            }
          }
          env {
            name  = "CASSANDRA_SEEDS"
            value = "cassandra-0.cassandra.default.svc.cluster.local"
          }
          env {
            name  = "CASSANDRA_AUTO_BOOTSTRAP"
            value = "true"
          }
          
          volume_mount {
            name      = "cassandra-data"
            mount_path = "/var/lib/cassandra"
          }
        }
      }
    }
    
    volume_claim_template {
      metadata {
        name = "cassandra-data"
      }
      spec {
        access_modes = ["ReadWriteOnce"] 
        
        resources {
          requests = {
            storage = "10Gi"  
          }
        }
      }
    }
  }
}
