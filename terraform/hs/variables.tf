variable "aws_region" {
  default = "us-east-1"
}

variable "s3_state_bucket" {
  default = "terraform-state-bucket"
}

variable "aws_credential_profile" {
  default = "helpscout-demo"
}

variable "vpc_cidr" {
  default = "10.10.0.0/19"
}

variable "dns_servers" {
  default = "AmazonProvidedDNS"
}

variable "env" {
  default = "HelpScout"
}

variable "nginx_ami" {}

variable "haproxy_ami" {}

variable "cloudflare_ip_range" {
  default = "103.21.244.0/22,103.22.200.0/22,103.31.4.0/22,104.16.0.0/12,108.162.192.0/18,131.0.72.0/22,141.101.64.0/18,162.158.0.0/15,172.64.0.0/13,173.245.48.0/20,188.114.96.0/20,190.93.240.0/20,197.234.240.0/22,198.41.128.0/17,199.27.128.0/21"
}
