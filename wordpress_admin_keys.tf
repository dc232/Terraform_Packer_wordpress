resource "aws_key_pair" "admin_key" {
    key_name = "wordpress_terraform_puplic_key"
    puplic_key = "${file("${var.aws_ssh_admin_key_file}.pub")}"
}