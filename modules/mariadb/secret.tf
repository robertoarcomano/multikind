resource "kubernetes_secret" "mariadb" {
  metadata {
    name = "mariadb-secret"
  }

  data = {
    mariadb_root_password = "root"
  }

  type = "Opaque"
}
