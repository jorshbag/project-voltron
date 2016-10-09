variable "availability_zones" {
  default = {
    us-east-1 = "a,b"
  }
}

variable "env" {
  default = "HelpScout"
}

variable "dns_servers" {}

variable "region" {}

variable "vpc_cidr" {}
