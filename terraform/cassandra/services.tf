resource "kubernetes_service_v1" "cassandra_headless" {
  metadata {
    name      = "cassandra"
    namespace = "default"
  }
  
  spec {
    port {
      port        = 9042
      target_port = 9042
    }
    
    selector = {
      app = "cassandra"
    }
    
    cluster_ip = "None"
  }
  
  depends_on = [kubernetes_stateful_set_v1.cassandra]
}

resource "kubernetes_service_v1" "cassandra_nodeport" {
  metadata {
    name      = "cassandra-nodeport"
    namespace = "default"
  }
  
  spec {
    type = "NodePort"
    
    port {
      port       = 9042
      target_port = 9042
      node_port  = 30001
      protocol   = "TCP"
      name       = "cql"
    }
    
    selector = {
      app = "cassandra"
    }
  }
  
  depends_on = [kubernetes_stateful_set_v1.cassandra]
}
