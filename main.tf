variable "enable_pod" {
  type    = bool
  default = false
}

variable "enable_ssh_server" {
  type    = bool
  default = false
}

variable "replicas" {
  type = number
  default = 1
}

variable "enable_cassandra" {
  type    = bool
  default = false
}

module "ssh_server" {
  source = "./modules/ssh_server"
  count = var.enable_ssh_server ? 1 : 0
  replicas = var.replicas
}

module "pod" {
  source = "./modules/pod"
  count = var.enable_pod ? 1 : 0
}

module "cassandra" {
  source = "./modules/cassandra"
  count = var.enable_cassandra ? 1 : 0
}
