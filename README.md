# Terraform_Packer_wordpress
An experiment to see if a wordpress AMI can be made as automatically as possible 
some user intervention is needed becuase of the way the secrets work

1. To make it work simply ensure that you specifiy your AWS credentials either in:

* ~/.aws/credentials (This will cater for both terraform files)
* or within RDS.tf
* or Packer_Newly_Created_AMI.tf

2. Then `chmod +x runme.sh, wordpress_updated.sh, wordpress_wpconfig.sh`
3. `./runme.sh`

BEFORE RUNNING THE SCRIPT NOTE: The script by deafult will assume you have set up the AWS credentials this way via the AWS command line 
I plan to relase an update to the Hashicorp suite install script to add the AWS secret and Acess keys via the .aws folder

Salt information will now populate automatically in the wordpress_wpconfig.sh file

