variable "availability_zones" {
  default = {
    us-east-1 = "a,b"
  }
}

variable "env" {
  default = "HelpScout"
}

variable "region" {}

variable "vpc_cidr" {}

variable "vpc_id" {}

variable "dmz_subnets" {
  type = "list"
}

variable "cloudflare_ip_range" {}

variable "haproxy_ami" {}
