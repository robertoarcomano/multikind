resource "kubernetes_service_v1" "ssh_server_headless" {
  metadata {
    name      = "ssh-server"
    namespace = "default"
  }
  
  spec {
    port {
      port        = 22
      target_port = 22
    }
    
    selector = {
      app = "ssh-server"
    }
    
    cluster_ip = "None"
  }
  
  depends_on = [kubernetes_stateful_set_v1.ssh-server]
}

resource "kubernetes_service_v1" "ssh-server-nodeport" {
  metadata {
    name      = "ssh-server-nodeport"
    namespace = "default"
  }
  
  spec {
    type = "NodePort"
    
    port {
      port       = 22
      target_port = 22
      node_port  = 30003
      protocol   = "TCP"
      name       = "ssh"
    }
    
    selector = {
      app = "ssh-server"
    }
  }
  
  depends_on = [kubernetes_stateful_set_v1.ssh-server]
}
