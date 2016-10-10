module "public_http_sg" {
  source      = "../core/sg"
  name        = "Public-HTTP-SG"
  env         = "${var.env}"
  vpc_id      = "${var.vpc_id}"
  description = "Public HTTP/S Security Group"
}

resource "aws_security_group_rule" "public_http_sg_443" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["${split(",", var.cloudflare_ip_range)}"]
  security_group_id = "${module.public_http_sg.id}"
}

resource "aws_security_group_rule" "public_http_sg_80" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["${split(",", var.cloudflare_ip_range)}"]
  security_group_id = "${module.public_http_sg.id}"
}
