provider "aws" {
  region      = "${var.aws_region}"
  profile     = "${var.aws_credential_profile}"
  max_retries = 5
}

data "terraform_remote_state" "helpscout" {
    backend = "s3"
    config {
        bucket = "terraform-state-helpscout-demo"
        key = "jsimmonds-demo/terraform.tfstate"
        region = "us-east-1"
        profile = "${var.aws_credential_profile}"
    }
}

module "network" {
  source      = "../aws/modules/network"
  env         = "${var.env}"
  region      = "${var.aws_region}"
  dns_servers = "${var.dns_servers}"
  vpc_cidr    = "${var.vpc_cidr}"
}

module "nginx" {
  source          = "../aws/modules/nginx"
  env             = "${var.env}"
  region          = "${var.aws_region}"
  vpc_cidr        = "${module.network.cidr}"
  nginx_ami       = "${var.nginx_ami}"
  app_subnets     = ["${module.network.app_subnets}"]
  vpc_id          = "${module.network.vpc_id}"
  route53_zone_id = "${module.network.route53_zone_id}"
}

module "haproxy" {
  source              = "../aws/modules/haproxy"
  env                 = "${var.env}"
  region              = "${var.aws_region}"
  vpc_cidr            = "${module.network.cidr}"
  haproxy_ami         = "${var.haproxy_ami}"
  dmz_subnets         = ["${module.network.dmz_subnets}"]
  vpc_id              = "${module.network.vpc_id}"
}
