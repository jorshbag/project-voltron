//Route Tables
resource "aws_route_table" "dmz_rt" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.env} DMZ"
  }
}

resource "aws_route_table" "app_rt" {
  vpc_id = "${aws_vpc.main.id}"

  tags {
    Name = "${var.env} App"
  }
}

// DMZ (For ELB) Routes
resource "aws_route" "dmz_gateway" {
  route_table_id         = "${aws_route_table.dmz_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.main_igw.id}"
}

// Webapp Layer Routes
resource "aws_route" "app_gateway" {
  route_table_id         = "${aws_route_table.app_rt.id}"
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = "${aws_nat_gateway.gw.id}"
}

resource "aws_route_table_association" "dmz_rt_asc_0" {
  route_table_id = "${aws_route_table.dmz_rt.id}"
  subnet_id      = "${aws_subnet.dmz_subnets.0.id}"
}

resource "aws_route_table_association" "dmz_rt_asc_1" {
  route_table_id = "${aws_route_table.dmz_rt.id}"
  subnet_id      = "${aws_subnet.dmz_subnets.1.id}"
}

resource "aws_route_table_association" "app_rt_asc_0" {
  route_table_id = "${aws_route_table.app_rt.id}"
  subnet_id      = "${aws_subnet.app_subnets.0.id}"
}

resource "aws_route_table_association" "app_rt_asc_1" {
  route_table_id = "${aws_route_table.app_rt.id}"
  subnet_id      = "${aws_subnet.app_subnets.1.id}"
}
