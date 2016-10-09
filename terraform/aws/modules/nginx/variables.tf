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

variable "nginx_ami" {}

variable "vpc_id" {}

variable "dmz_subnets" {
  type = "list"
}

variable "app_subnets" {
  type = "list"
}

variable "cloudflare_ip_range" {}

variable "route53_zone_id" {}
