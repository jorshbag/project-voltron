resource "aws_instance" "haproxy_node" {
  ami                    = "${var.haproxy_ami}"
  instance_type          = "t2.micro"
  subnet_id              = "${var.dmz_subnets[0]}"
  vpc_security_group_ids = ["${module.public_http_sg.id}"]
  key_name               = "helpscout-keypair"
  create_before_destroy  = true

}
