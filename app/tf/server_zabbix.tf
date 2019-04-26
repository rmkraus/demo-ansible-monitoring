# zabbix server
resource "aws_instance" "zabbix" {
  ami                    = "${var.ami_id}"
  instance_type          = "${var.zabbix_instance_type}"
  subnet_id              = "${aws_subnet.main.id}"
  vpc_security_group_ids = ["${aws_security_group.main.id}"]
  key_name               = "${aws_key_pair.main.id}"
  availability_zone      = "${var.aws_availability_zone}"
  depends_on             = ["aws_subnet.main"]

  tags = {
    Name                 = "${var.demo_prefix}_zabbix"
  }
}
resource "aws_eip" "zabbix" {
  instance               = "${aws_instance.zabbix.id}"
  vpc                    = true
  depends_on             = ["aws_instance.zabbix"]

  tags = {
    Name                 = "${var.demo_prefix}_zabbix_eip"
  }
}
resource "aws_route53_record" "zabbix" {
  zone_id = "${var.aws_r53_zone_id}"
  name    = "zabbix.${var.demo_prefix}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_eip.zabbix.public_ip}"]
  depends_on = ["aws_eip.zabbix"]
}
resource "aws_route53_record" "zabbix_int" {
  zone_id = "${var.aws_r53_zone_id}"
  name    = "int.zabbix.${var.demo_prefix}"
  type    = "A"
  ttl     = "300"
  records = ["${aws_instance.zabbix.private_ip}"]
  depends_on = ["aws_instance.zabbix"]
}
