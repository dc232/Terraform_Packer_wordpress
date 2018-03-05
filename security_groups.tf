/* provider "aws" {
    access_key  = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "${var.aws_region}" 
} */

#defines the new resource being made in this case this is the AWS security group
resource "aws_security_group" "rules" {
  name        = "Wordpress Security Group Rules"
  description = "Allows inbound and outbound traffic"
}

variable "http_ports" {
  default = ["80", "443", "3306", "22"]
}

#defines inbound rules set by the http_ports variable
resource "aws_security_group_rule" "ingress_http" {
  count = "${length(var.http_ports)}"

  type        = "ingress"
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  from_port   = "${element(var.http_ports, count.index)}"
  to_port     = "${element(var.http_ports, count.index)}"

  security_group_id = "${aws_security_group.rules.id}"
}

#defines outbound rules stating that all ports will be open on the outbound
resource "aws_security_group_rule" "egress_rules" {
    type = "egress"
    protocol ="-1"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 0
    to_port = 0
    security_group_id = "${aws_security_group.rules.id}"
}
