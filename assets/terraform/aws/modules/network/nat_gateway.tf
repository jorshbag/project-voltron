resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = "${aws_eip.nat_eip.id}"
  subnet_id     = "${aws_subnet.dmz_subnets.0.id}"
  depends_on    = ["aws_internet_gateway.main_igw", "aws_subnet.dmz_subnets"]
}
