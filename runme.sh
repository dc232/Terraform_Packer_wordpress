#!/bin/bash

packer_run_wordpress_AMI_creation () {
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
echo "Building packer iamge from fistrun.json, please ensure AWS secret and Access keys have been specified/setup as well as AWS Region"
 packer build -machine-readable example.json | tee build.log
 #creates a log called build.log but also displays the machine reable output to standard output
 TERRAFORM_AMI_NAME=$(egrep -m1 -oe 'ami-.{8}' build.log)
 sed -i 's/AMI_ID/'$TERRAFORM_AMI_NAME'/' Packer_Newly_Created_AMI.tf
 #where m is the max count 
 #o is the the only mactching
 #l is the filre with matches
 #line above gives ami id automatiaclly for deployment
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
TERRAFORM_DATABBASE_ENDPOINT=$(terraform show | grep endpoint | sed 's/endpoint//g' | tr -d = | tr -d ' ')
TERRAFORM_DATABBASE_USERNAME=$(terraform show | grep username | sed 's/username//g' | tr -d = | tr -d ' ')
TERRAFORM_DATABASE_PASSWORD=$(terraform show | grep password | sed 's/password//g' | tr -d = | tr -d ' ')

cat << EOF
######################################################
Substituting password, username and database endpoint
for the computed values
######################################################
EOF

sleep 2

sed -i.bak 's/dbhost/'$TERRAFORM_DATABBASE_ENDPOINT'/' wordpress_wpconfig.sh
sed -i 's/dbusername/'$TERRAFORM_DATABBASE_USERNAME'/' wordpress_wpconfig.sh
sed -i 's/dbpassword/'$TERRAFORM_DATABASE_PASSWORD'/' wordpress_wpconfig.sh

#a terraform.tsstate file should be created 
#when the terraform code executes sucessfully 
#the command will show the attributes assioated 
#with the Amazon Resource we just created
# the tr command means translate or delete characters -d operand meand delete white space
else
echo "installing packer to /usr/bin/terraform "
wget https://releases.hashicorp.com/packer/$TERRAFORM_VERSION/packer_"$TERRAFORM_VERSION"_linux_amd64.zip
sudo unzip packer_"$TERRAFORM_VERSION"_linux_amd64.zip -d /usr/bin
fi
}


Terraform_Deploy_Packer_AMI () {
echo "Deploying Newly created Wordpress AMI"
sleep 1
terraform init
terraform apply Packer_Newly_Created_AMI.tf -auto-approve
}

overall_script () {
terraform_check
packer_run_wordpress_AMI_creation
Terraform_Deploy_Packer_AMI
}

Secret_Management () {
AWS_CREDS=~/.aws/credentials
cat << EOF
######################################################
Checking to see if $AWS_CREDS exists
######################################################
EOF

sleep 1 
#To make the variable word with tildi it must not be quoted see https://serverfault.com/questions/417252/check-if-directory-exists-using-home-character-in-bash-fails for detials


    if [ -f "$AWS_CREDS" ]; then
    echo "AWS credentials found using them instead of Secrets.tf"
    sleep 1
    echo "Proceeding to run the rest of the script"
    overall_script
    else
    echo "No $AWS_CREDS file found reveting to use the Secrets.tf file"
    sleep 1 
    echo "uncommenting secrets to run the rest of the script"
    sleep 1
    find . -type f -name '*.tf' -exec sed -i 's/\///g' {} \; #finds in the local directory . any tf file then executes sed on all thoose files
    find . -type f -name '*.tf' -exec sed -i 's/\*//g' {} \;
    overall_script
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




