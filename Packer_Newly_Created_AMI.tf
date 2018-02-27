/* provider "aws" {
    access_key  = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "${var.aws_region}" 
} */

resource "aws_eip_association" "eip_assoc" {
  instance_id   = "${aws_instance.web.id}"
  allocation_id = "${aws_eip.eipvpc.id}"
}

resource "aws_instance" "web" {
  ami           = "AMI_ID"
#  availablity_zone = "us-west-2a"
  instance_type = "t2.micro"
  security_groups = [
    "${aws_security_group.rules.name}"
   ]
}

resource "aws_eip" "eipvpc" {
  vpc = "true"
}
