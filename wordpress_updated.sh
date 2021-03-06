#!/bin/bash

####################################
#GLOBAL VARS
####################################
OS_CHECK="$(grep debian /etc/os-release)"
OS_CODENAME=$(grep VERSION_CODENAME /etc/os-release | sudo sed '/VERSION_CODENAME/,$!d' /etc/os-release | sed 's/UBUNTU_CODENAME=xenial//g' | sed 's/VERSION_CODENAME=//g')
SOURCES_DIR="/etc/apt/sources.list.d"
key="ABF5BD827BD9BF62"

symlinks () {
        echo "creating symlinks for nginx and php"
        sleep 1
        ln -s /var/log/nginx ~/nginx_logs
        ln -s /var/log/php ~/php_logs
        ln -s /var/www/html/wordpress ~/wordpress_content_directory
}

wp_cli () {
        echo "installing the latest version of WP-CLI"
        sleep 1
        sudo curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        sleep 1
        echo "verifying that the wp-cli.phar file is working"
        sleep 1
        php wp-cli.phar --info
        echo "changing file permissions of wp-cli.phar"
        sleep 1
        sudo chmod +x wp-cli.phar
        echo "renaming file to wp and moving to binary directory /usr/local/bin"
        sleep 1
        sudo mv wp-cli.phar /usr/local/bin/wp
        echo "checking that binary exists for file wp"
        sleep 1
        which wp
        echo "checking to see if wp-cli is installed correctly"
        wp --info
        echo "adding tab completion"
        sleep 1
        wget --progress=bar:force https://raw.githubusercontent.com/wp-cli/wp-cli/master/utils/wp-completion.bash -P ~
        echo "sourcing wp-completion.bash to ~/.profile"
        sleep 1
        source ~/wp-completion.bash
        source ~/.profile
}

diags () {
echo "showing mariadb server satus (if using local DB server config)"
systemctl status mariadb.service
sleep 1 
echo "checking nginx config file status for errors"
sleep 1
nginx -t
sleep 2
echo "showing nginx status"
systemctl status nginx.service
sleep 1 
echo "showing php status"
sudo systemctl status php7.1-fpm.service
}



update_upgrade () {
sudo apt-get update && sudo apt-get upgrade -y 
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
sudo sed -i 's/cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.1/cli/php.ini
echo "restarting service"
sudo systemctl restart php7.1-fpm.service
echo "checking php cli"
sleep 1 
php -v
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
sudo apt install expect -y
#// Not required in actual script
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

sudo apt purge expect -y
}

wordpress_setup () {
cat <<EOF
###############################
Installing Wordpress
###############################
EOF
sleep 1

echo "installing zip"
sudo apt install zip unzip -y
wget --progress=bar:force https://wordpress.org/latest.zip
sudo unzip latest.zip 1>/dev/null
echo "printing working directory (debug)"
pwd
sudo mkdir /var/www/
sudo mkdir /var/www/html
#mv wordpress/* /var/www/html/
sudo mv wordpress/ /var/www/html/
echo changing file owners permisions 
sleep 2
cd /var/www/html/
sudo find . -type d -exec chown www-data:www-data {} \;
sudo find . -type f -exec chown www-data:www-data {} \;
cd /var/www/html/wordpress/
sudo find . -type d -exec chown www-data:www-data {} \;
sudo find . -type f -exec chown www-data:www-data {} \;
}


nginx_conf () {
echo "creating new configuration"
sleep 1
echo "moving default nginx configuration in dir /etc/nginx/conf.d/"
sleep 1
sudo mv /etc/nginx/conf.d/default.conf /etc/nginx/
echo "creating nginx configuration file"
sleep 1
sudo cat << EOF >>wordpress.conf
server {
        listen 80;
        listen [::]:80 default_server;
        server_name _;
        root /var/www/wordpress;
        index index.php;
        client_max_body_size 900m;

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
        root   /usr/share/nginx/html;
        }

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
echo "moving nginx configuration"
sleep 1
ls -l 
sudo mv wordpress.conf /etc/nginx/conf.d/
ls -l /etc/nginx/conf.d/
sleep 5
echo "checking to see if file was created (debug code)"
wordpress_configuration_file="/etc/nginx/conf.d/wordpress.conf"
if ["$wordpress_configuration_file"]; then
echo "wordpress config created sucessfully"
find /etc/nginx/conf.d/ -name wordpress.conf
sleep 1 
else
echo "file has not been created"
ls -l /etc/nginx/conf.d/
fi
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


echo "creating nginx-ppa.list file"
sleep 1

sudo cat<< EOF >> nginx-ppa.list
deb http://nginx.org/packages/ubuntu/ $OS_CODENAME nginx
deb-src http://nginx.org/packages/ubuntu/ $OS_CODENAME nginx
EOF

echo "moving nginx-ppa.list to  $SOURCES_DIR"
sleep 1
sudo mv nginx-ppa.list $SOURCES_DIR

nginx_PPA="grep nginx-ppa.list $SOURCES_DIR"
echo "debug code for testing purposes"
if [ "$nginx_PPA" ]; then 
echo "the file was created successfully"
cat $SOURCES_DIR/nginx-ppa.list
else 
echo "nginx-ppa.list failed to be created exiting"
exit 0
fi

echo "Setting up nginx Official repository gpg signing"
sleep 1
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys $key
echo "installing nginx"
sleep 2
sudo apt-get update && sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl status nginx

echo "checking directories"
sleep 1
cat /etc/nginx/nginx.conf 
sleep 2
ls -l /usr/share/nginx/html
sleep 2
 ls -l /etc/nginx/conf.d/
sleep 5
}

overall_install () {
if [ "OS_CHECK" ]; then 
echo "The OS that you have is Ubuntu"
sleep 1
echo "Proceeding to update and upgrade the system"
update_upgrade
sleep 1
echo "installing nginx"
nginx_install
sleep 1
echo "configuring nginx"
nginx_conf
#echo "installing mariadb"
#sleep 1
#mariad_install
#echo "configuring mariadb"
#sleep 1
#mariadb_conf
echo "installing php"
php_install
sleep 1
echo "configuring php"
php_conf
echo "setting up wordpress"
sleep 1
wordpress_setup
echo "installing wp-cli"
sleep 1
wp_cli
echo "checking diagnostics"
diags
echo "adding log and wordpress work directory symlinks"
symlinks
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
