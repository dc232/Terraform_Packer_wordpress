# Terraform_Packer_wordpress
An experiment to see if a wordpress AMI can be made as automatically as possible 
some user intervention is needed becuase of the way the secrets work

To make it work simply ensure that you specifiy your AWS credentials either in:
~/.aws/credentials
or within RDS.tf
The script by deafult will assume you have set up the AWS credentials this way via the AWS command line 
I plan to relase an update to the Hashicorp suite install script to add the AWS secret and Acess keys via the .aws folder

