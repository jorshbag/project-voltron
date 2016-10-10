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

variable "app_subnets" {
  type = "list"
}
variable "route53_zone_id" {}
