/* provider "aws" {
    access_key  = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
    region     = "${var.aws_region}" 
} */

resource "aws_db_instance" "RDS" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "MariaDB"
  engine_version       = "10.0.24"
  instance_class       = "db.t2.micro"
  name                 = "MariaDB_Wordpress"
  username             = "wordress"
  password             = "Wordpress"
  db_subnet_group_name = "default"
  parameter_group_name = "default.mariadb10.0"
}
