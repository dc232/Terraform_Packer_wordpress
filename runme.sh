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
echo "executing teraform script"
teraform RDS.tf
sleep 1
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
PACKER_BIN
