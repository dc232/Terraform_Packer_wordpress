/* provider "aws" {
    access_key  = "ACCESS_KEY_HERE"
    secret_key = "SECRET_KEY_HERE"
    region     = "us-west-2" 
} */

resource "aws_instance" "example" {
    ami           = "AMI_ID"
    instance_type = "t2.micro"
}