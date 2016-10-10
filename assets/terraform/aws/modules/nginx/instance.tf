resource "aws_instance" "nginx_node_1" {
  ami                    = "${var.nginx_ami}"
  instance_type          = "t2.micro"
  subnet_id              = "${var.app_subnets[0]}"
  vpc_security_group_ids = ["${module.nginx_sg.id}"]
  key_name               = "helpscout-keypair"
  create_before_destroy  = true
}

resource "aws_instance" "nginx_node_2" {
  ami                    = "${var.nginx_ami}"
  instance_type          = "t2.micro"
  subnet_id              = "${var.app_subnets[1]}"
  vpc_security_group_ids = ["${module.nginx_sg.id}"]
  key_name               = "helpscout-keypair"
  create_before_destroy  = true
}

resource "aws_route53_record" "nginx1" {
   zone_id = "${var.route53_zone_id}"
   name = "nginx_node_1"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.nginx_node_1.private_ip}"]
}

resource "aws_route53_record" "nginx2" {
   zone_id = "${var.route53_zone_id}"
   name = "nginx_node_2"
   type = "A"
   ttl = "300"
   records = ["${aws_instance.nginx_node_2.private_ip}"]
}
