output "name" {
  value = "${aws_vpc.main.tags.Name}"
}

output "cidr" {
  value = "${aws_vpc.main.cidr_block}"
}

output "vpc_id" {
  value = "${aws_vpc.main.id}"
}

output "dmz_subnets" {
  value = ["${aws_subnet.dmz_subnets.*.id}"]
}

output "app_subnets" {
  value = ["${aws_subnet.app_subnets.*.id}"]
}

output "route53_zone_id" {
  value = "${aws_route53_zone.helpscout-internal.zone_id}"
}
