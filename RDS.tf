/* provider "aws" {
  access_key = "XXXXXXXXXXXXXXXXXXXXXXX"
  secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXX"
  region     = "us-west-2"
} */

resource "aws_db_instance" "RDS" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "MariaDB"
  engine_version       = "10.0.24"
  instance_class       = "db.t2.micro"
  name                 = "MariaDB_Wordpress"
  username             = "worpress"
  password             = "Wordpress"
  db_subnet_group_name = "default"
  parameter_group_name = "default.mariadb10.0"
}

#example from terraform
/* resource "aws_db_instance" "default" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.6.17"
  instance_class       = "db.t1.micro"
  name                 = "mydb"
  username             = "foo"
  password             = "bar"
  db_subnet_group_name = "my_database_subnet_group"
  parameter_group_name = "default.mysql5.6"
} */
