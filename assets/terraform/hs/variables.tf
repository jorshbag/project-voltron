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
