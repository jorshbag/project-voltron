resource "aws_vpc_dhcp_options" "dhcp_options" {
  domain_name         = "${lower(var.env)}.internal"
  domain_name_servers = ["${split(",", var.dns_servers)}"]

  tags {
    Name = "${var.env}_DHCP"
  }
}

resource "aws_vpc_dhcp_options_association" "dns_resolver" {
  vpc_id          = "${aws_vpc.main.id}"
  dhcp_options_id = "${aws_vpc_dhcp_options.dhcp_options.id}"
}
