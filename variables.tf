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

variable "cassandra_replicas" {
  type = number
  default = 1
}

variable "enable_cassandra" {
  type    = bool
  default = false
}

variable "enable_k8ssandra_cluster" {
  type    = bool
  default = false
}

variable "enable_k8ssandra_operator" {
  type    = bool
  default = false
}

variable "k8ssandra_replicas" {
  type = number
  default = 1
}
