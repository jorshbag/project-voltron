module "nginx_sg" {
  source      = "../core/sg"
  name        = "Nginx-Internal-SG"
  env         = "${var.env}"
  vpc_id      = "${var.vpc_id}"
  description = "Internal HTTP/S Security Group"
}

resource "aws_security_group_rule" "nginx_sg_443" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["${var.vpc_cidr}"]
  security_group_id = "${module.nginx_sg.id}"
}

resource "aws_security_group_rule" "nginx_sg_80" {
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["${var.vpc_cidr}"]
  security_group_id = "${module.nginx_sg.id}"
}
