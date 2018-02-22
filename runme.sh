#!/bin/bash

packer_run () {
####################################
# Private VARS
####################################
PACKER_BIN=$(which packer)
PACKER_VERSION="1.2.0"

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
Checking to see that packe  has been 
installed
#####################################
EOF
sleep 2
packer
packer version
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
