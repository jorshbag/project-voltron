resource "aws_route53_zone" "helpscout-internal" {
  name       = "${lower(var.env)}.internal"
  vpc_id     = "${aws_vpc.main.id}"
  vpc_region = "${var.region}"
}
