provider "aws" {
  region      = "${var.aws_region}"
  profile     = "${var.aws_credential_profile}"
  max_retries = 5
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
  cloudflare_ip_range = "${var.cloudflare_ip_range}"
}
