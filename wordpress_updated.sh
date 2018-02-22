#!/bin/bash

####################################
#GLOBAL VARS
####################################
OS_CHECK="$(grep debian /etc/os-release)"
OS_CODENAME=$(grep VERSION_CODENAME /etc/os-release | sudo sed '/VERSION_CODENAME/,$!d' /etc/os-release | sed 's/UBUNTU_CODENAME=xenial//g' | sed 's/VERSION_CODENAME=//g')
UBUNTU_SOURCE_LIST="/etc/apt/sources.list"


diags () {
echo "showing mariadb server satus"
systemctl status mariadb-server.service
sleep 1 
echo "showing nginx status"
systemctl status ngix.service
sleep 1 
echo "showing php status"
sudo systemctl status php7.1-fpm.service
}



upgrade () {
apt-get update && apt-get upgrade -y 
}

php_install () {
echo "enabling repository and downloading php7.1"
sleep 2
sudo apt-get install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
echo "installing php7.1"
sudo apt-get install php7.1 php7.1-cli php7.1-common php7.1-json php7.1-opcache php7.1-mysql php7.1-mbstring php7.1-mcrypt php7.1-zip php7.1-fpm php7.1-soap -y
}

php_conf () {
echo "chaging cgi.fix_pathinfo"
sleep 1
sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.1/cli/php.ini
echo "restarting service"
sudo systemctl restart php7.1-fpm.service

}

mariad_install () {
cat <<EOF 
###############################################
Installing Mariadb from the offical repository
##############################################
EOF
sleep 1

cat <<EOF 
###############################################
Adding MariaDB Repo Keys
##############################################
EOF

sudo apt-get install software-properties-common -y
sudo apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xF1656F24C74CD1D8
sudo add-apt-repository 'deb [arch=amd64,i386,ppc64el] http://mirror.sax.uk.as61049.net/mariadb/repo/10.2/ubuntu xenial main'

cat <<EOF 
###############################################
Installing MariaDB                
##############################################
EOF
sudo apt-get update
sudo apt-get install mariadb-server mariadb-client -y

}

mariadb_conf () {
aptitude -y install expect

// Not required in actual script
MYSQL_ROOT_PASSWORD=abcd1234

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"

aptitude -y purge expect
}

wordpress_setup () {
cat <<EOF
###############################
Installing Wordpress
###############################
EOF
sleep 1

echo "installing zip"
apt-get install zip unzip -y
wget https://wordpress.org/latest.zip
unzip latest.zip
#mv wordpress/* /var/www/html/
mv wordpress/ /var/www/html/
echo changing file owners permisions 
sleep 2
cd /var/www/html/
find . -type d -exec chown www-data:www-data {} \;
find . -type f -exec chown www-data:www-data {} \;
cd /var/www/html/wordpress/
find . -type d -exec chown www-data:www-data {} \;
find . -type f -exec chown www-data:www-data {} \;
}


nginx_conf () {
mv /etc/nginx/sites-available/default /etc/nginx/
cat <<EOF >> /etc/nginx/sites-available/wordpress
server {
        listen 80;
        listen [::]:80 default_server;
        server_name _;
        root /var/www/wordpress;
        index index.php;
        client_max_body_size 900m;

        location / {
                try_files $uri $uri/ /index.php?q=$uri&$args;
        }

        location ~ \.php$ {
            fastcgi_pass unix:/run/php/php7.1-fpm.sock;
            include snippets/fastcgi-php.conf;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }

        location ~ /\.ht {
                deny all;
        }
}
EOF
nginx -t
}

nginx_install () {
cat <<EOF
#####################################
To aviod missing PGP keys error during
the nginx install we will know download
the key and set up the required repos
to install the latest version of nginx 
stable
#####################################
EOF

sleep 6

echo "Downloading key"
sleep 1
wget http://nginx.org/keys/nginx_signing.key
echo "adding nginx repos to the $UBUNTU_SOURCE_LIST"
sleep 1
echo deb http://nginx.org/packages/debian/ $OS_CODENAME nginx >> $UBUNTU_SOURCE_LIST
echo deb-src http://nginx.org/packages/debian/ $OS_CODENAME nginx >> $UBUNTU_SOURCE_LIST
echo "installing nginx"
sudo apt-get update && sudo apt-get install nginx -y
}

overall_install () {
if [ "OS_CHECK" ]; then 
echo "The OS that you have is Ubuntu"
sleep 1
echo "Proceeding to upgrade the system"
upgrade
sleep 1
echo "installing nginx"
nginx_install
sleep 1
echo "configuring nginx"
nginx_conf
echo "installing mariadb"
sleep 1
#mariad_install
#echo "configuring mariadb"
#sleep 1
#mariadb_conf
echo "installing php"
php_install
sleep 1
echo "configuring php"
php_conf
echo "displaying "
else
echo "This script cannot run on this system at the present moment"
exit 0
fi
}


cat <<EOF
#################################
This script is desighned to 
install wordpress on AWS VM
Ubuntu
It is desighned to be used with
the Hasicorp Suite script that 
I have created
#################################
EOF

sleep 5

overall_install
