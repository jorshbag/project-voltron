resource "aws_subnet" "dmz_subnets" {
  cidr_block              = "${cidrsubnet(aws_vpc.main.cidr_block, 4, count.index + 1)}"
  vpc_id                  = "${aws_vpc.main.id}"
  count                   = "${length(split(",",lookup(var.availability_zones, var.region)))}"
  map_public_ip_on_launch = "true"
  availability_zone       = "${var.region}${element(split(",",lookup(var.availability_zones, var.region)), count.index)}"

  tags {
    Name = "${var.env}_DMZ_${element(split(",",lookup(var.availability_zones, var.region)), count.index)}"
  }
}

resource "aws_subnet" "app_subnets" {
  cidr_block              = "${cidrsubnet(aws_vpc.main.cidr_block, 2, count.index + 1)}"
  vpc_id                  = "${aws_vpc.main.id}"
  count                   = "${length(split(",", lookup(var.availability_zones, var.region)))}"
  map_public_ip_on_launch = "false"
  availability_zone       = "${var.region}${element(split(",", lookup(var.availability_zones, var.region)), count.index)}"

  tags {
    Name = "${var.env}_APP_${element(split(",", lookup(var.availability_zones, var.region)), count.index)}"
  }
}
