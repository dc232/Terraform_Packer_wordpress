# Terraform_Packer_wordpress
An experiment to see if a wordpress AMI can be made as automatically as possible 
some user intervention is needed becuase of the way the secrets work

To make it work simply ensure that you specifiy your AWS credentials either in:

* ~/.aws/credentials (This will cater for both terraform files)
* or within RDS.tf
* or Packer_Newly_Created_AMI.tf

Then chmod +x runme.sh
./runme.sh

BEFORE RUNNING THE SCRIPT NOTE: The script by deafult will assume you have set up the AWS credentials this way via the AWS command line 
I plan to relase an update to the Hashicorp suite install script to add the AWS secret and Acess keys via the .aws folder

Please also update the salt paramters in the wordpress_wpconfig.sh file otherwise this can lead to security issues
to do this go to https://api.wordpress.org/secret-key/1.1/salt/
Then copy and paste as required, The only reason this part is not yet automated is becuase I have not yet worked out a good way of updating the salt information 

