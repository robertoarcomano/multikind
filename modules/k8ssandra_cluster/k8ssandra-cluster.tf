# K8ssandraCluster (contenuto di k8c1.yaml integrato)
resource "kubernetes_manifest" "k8c1" {
  manifest = {
    apiVersion = "k8ssandra.io/v1alpha1"
    kind       = "K8ssandraCluster"
    metadata = {
      name      = "cassandra-cluster"
      namespace = "default"
    }
    serverVersion = "4.1.0"
    spec = {
      cassandra = {
        datacenters = [{
          metadata = {
            name = "dc1"
          }
          size = var.k8ssandra_replicas
          storageConfig     = {
            persistentVolumeClaimSpec = {
              storageClassName = "standard"
              accessModes      = ["ReadWriteOnce"]
              resources = {
                requests = {
                  storage = "10Gi"
                }
              }
            }
          }
          rackConfig = {
            metadata = {
              name = "rack1"
            }
          }
        }]
      }
    }
  }

  computed_fields = [
    "status",
  ]
  
}
