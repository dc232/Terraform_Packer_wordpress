#!/bin/bash

packer_run () {
####################################
# Private VARS
####################################
PACKER_BIN=$(which packer)
PACKER_VERSION="1.2.0"
TERRAFORM_BIN=$(which terraform)
TERRAFORM_VERSION="0.11.3"

if [ "$PACKER_BIN" ]; then
echo "validating packer"
sleep 1
packer validate fistrun.json
sleep 1
packer fistrun.json
else
echo "installing packer to /usr/bin/packer "
wget https://releases.hashicorp.com/packer/$PACKER_VERSION/packer_"$PACKER_VERSION"_linux_amd64.zip
sudo unzip packer_"$PACKER_VERSION"_linux_amd64.zip -d /usr/bin
cat << EOF
#####################################
Checking to see that packer has been 
installed
#####################################
EOF
sleep 2
packer
packer version
fi
}


terraform_check () {
if [ "$TERRAFORM_BIN" ]; then
cat << EOF
#######################################################
executing terraform script, Please not that this script
will check for the  ~/.aws/credentials file 1st as the 
AWS secret and Acess keys are explicted difined in the 
RDS.tf scriptm If you need to set them explicitly 
please see RDS.tf
######################################################
EOF 
sleep 7
echo "Initialising terraform backend which means that it will look for the AWS service provider plugin"
sleep 2
terraform init
cat <<EOF
######################################################
running terraform plan to see the changes brought about in the AWS infrastructure, 
the terraform apply command works for terraform 0.11 and 
above directly before the appliction of terraform plan
######################################################
EOF
sleep 4 
terraform plan
echo "running terraform apply"
sleep 1
terraform apply -auto-approve #auto-approve allows for the suppression of confirmation promts and automatically 
#deploys the infrasture we still know what changes 
#thanks to terraform plan altohugh terraform apply now does the same thing 
#as plan but promts us to approve the changes before applying thats the only diffrece between them
echo "showing terraform computed changes"
sleep 1 
terraform show
else
echo "installing packer to /usr/bin/terraform "
wget https://releases.hashicorp.com/packer/$TERRAFORM_VERSION/packer_"$TERRAFORM_VERSION"_linux_amd64.zip
sudo unzip packer_"$TERRAFORM_VERSION"_linux_amd64.zip -d /usr/bin
fi
}


cat <<EOF
################################
This script is desighned to execute 
the packer example 1st run json file 
and if packer does not exist then
install it
################################
EOF

sleep 5
packer_run
terraform_check
