resource "aws_security_group" "base_security_group" {
  name        = "${var.env}-${var.name}"
  description = "${var.description}"
  vpc_id      = "${var.vpc_id}"

  tags {
    Name = "${var.env}-${var.name}"
    Env  = "${var.env}"
  }
}

resource "aws_security_group_rule" "default_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = "${aws_security_group.base_security_group.id}"
}
