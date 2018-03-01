#!/bin/bash
####################################
# Global VARS
####################################
PACKER_BIN="echo $(which packer)"
PACKER_VERSION="1.2.0"
TERRAFORM_BIN="echo $(which terraform)"
TERRAFORM_VERSION="0.11.3"

packer_run_wordpress_AMI_creation () {

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

cat << EOF
######################################################
Creating SSH keys to manage the wordpress AMI
######################################################
EOF
sleep 1 
echo "creating puplic and private key pair"
sleep 1
mkdir key
ssh-keygen -t rsa -b 4906 -f key/wordpress_terraform_key -C wordpress_terrafrom_key_pair -N '' #where b means bits t means type and f means filename C means comment, N mean to set the passphrase ib this case there is no passphase

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
echo "installing terraform to /usr/bin/terraform"
wget https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_"$TERRAFORM_VERSION"_linux_amd64.zip
sudo unzip terraform_"$TERRAFORM_VERSION"_linux_amd64.zip -d /usr/bin
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
AWS_VAR_SECRET_KET="$(grep SecretKey Secrets.tf)"
AWS_VAR_ACCESS_KEY="$(grep AcessKey Secrets.tf)"
AWS_CONFIG=~/.aws/config
AWS_VAR_REGION="$(grep region $AWS_CONFIG | sed 's/region//g' | tr -d = | tr -d ' ')"
cat << EOF
######################################################
Checking to see if $AWS_CREDS exists
######################################################
EOF

sleep 1 
#To make the variable word with tildi it must not be quoted see https://serverfault.com/questions/417252/check-if-directory-exists-using-home-character-in-bash-fails for detials


    if [[ -f "$AWS_CREDS" && -f "$AWS_CONFIG" ]]; then
    echo "AWS credentials and config found using them instead of Secrets.tf"
    sleep 1
    echo "Preparing Secrets.tf file with region information from $AWS_CONFIG"
    sleep 1
    sed -i 's/Region/'$AWS_VAR_REGION'/' Secrets.tf
    sed -i 's/#//g' $AWS_VAR_REGION
    echo "Proceeding to run the rest of the script"
    sleep 1
    overall_script
    elif [[ "$AWS_VAR_SECRET_KET" &&  "$AWS_VAR_ACCESS_KEY" ]]; then 
    echo "please change the AWS secret key and AWS acess key from there default values before continuing"
    sleep 1
    echo  "uncommenting Secrets.tf and all other .tf files to allow for AWS acess key and AWS secret key to be entered in this file"
    sleep 5
    find . -type f -name '*.tf' -exec sed -i 's/\///g' {} \; #finds in the local directory . any tf file then executes sed on all thoose files
    find . -type f -name '*.tf' -exec sed -i 's/\*//g' {} \;
    exit 0
    else
    echo "No $AWS_CREDS file found reveting to use the Secrets.tf file"
    sleep 1 
    echo "you have changed the values in the Serets.tf file"
    sleep 1 
    echo "continuing to uncommenting secrets to allow for the rest of the script to run"
    sleep 1
    find . -type f -name '*.tf' -exec sed -i 's/\///g' {} \; #finds in the local directory . any tf file then executes sed on all thoose files
    find . -type f -name '*.tf' -exec sed -i 's/\*//g' {} \;
    echo "Runing the rest of the script"
    sleep 1
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
Secret_Management

