resource "kubernetes_namespace_v1" "k8ssandra_operator" {
  metadata {
    name = "k8ssandra-operator"
  }
}

resource "helm_release" "k8ssandra_operator" {
  name       = "k8ssandra-operator"
  repository = "https://helm.k8ssandra.io/stable"
  chart      = "k8ssandra-operator"
  namespace  = kubernetes_namespace_v1.k8ssandra_operator.metadata[0].name

  set {
    name  = "global.clusterScoped"
    value = "true"
  }

  depends_on = [
    kubernetes_namespace_v1.k8ssandra_operator,
    helm_release.cert_manager
  ]
}
