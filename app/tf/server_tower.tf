# tower server
resource "aws_instance" "tower" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.tower_instance_type}"
  subnet_id              = "${aws_subnet.main.id}"
  vpc_security_group_ids = ["${aws_security_group.main.id}"]
  key_name               = "${aws_key_pair.main.id}"
  availability_zone      = "${var.aws_availability_zone}"
  depends_on             = ["aws_subnet.main"]

  tags = {
    Name                 = "${var.demo_prefix}_tower"
  }
}
resource "aws_eip" "tower" {
  instance               = "${aws_instance.tower.id}"
  vpc                    = true
  depends_on             = ["aws_instance.tower"]

  tags = {
    Name                 = "${var.demo_prefix}_tower_eip"
  }
}
resource "aws_route53_record" "tower" {
  zone_id = "${var.aws_r53_zone_id}"
  name    = "tower.${var.demo_prefix}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.tower.public_ip}"]
}
