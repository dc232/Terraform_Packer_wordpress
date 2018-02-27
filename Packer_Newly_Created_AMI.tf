/* provider "aws" {
    access_key  = "ACCESS_KEY_HERE"
    secret_key = "SECRET_KEY_HERE"
    region     = "us-west-2" 
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
