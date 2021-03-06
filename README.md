# Terraform_Packer_wordpress
An experiment to see if a WordPress AMI can be made as automatically as possible 
Some user intervention is needed because of the way the secrets work

This base model houses the following

* The latest version of Nginx stable from the official repositories
* PHP 7.1 from the ondrej/php repository
* MariaDB 10.2 from the official repository
* The latest version of WordPress

Please uncomment the following in wordpress_updated.sh to use MariaDB locally

* #mariad_install
* #echo "configuring mariadb"
* #sleep 1
* #mariadb_conf

Then also comment the function `terraform_check` in runme.sh to use MariaDB locally

I will provide an additional script that can be run to allow for local DB installs in the future


1. To make it work simply ensure that you specify your AWS credentials either in:

* ~/.aws/credentials (This will cater for both terraform files)
* or within RDS.tf
* or Packer_Newly_Created_AMI.tf

2. Then `chmod +x runme.sh, wordpress_updated.sh, wordpress_wpconfig.sh`
3. `./runme.sh`

Salt information will now populate automatically in the wordpress_wpconfig.sh file

* Additional planned features 
* Nginx caching
* Reddis integration 
* SSL integration
* Carridge return linting (incase ^M is seen on standard out when cating the wp-config file) (uncessary as all files are LF not CRLF)
* symlinks to `/var/log/nginx` and`/var/log/php` for systems administrator debuging
* symlinks to `/etc/php` to adjust the `php.ini` file parameters (this may be added to the script in the future)
* Elastic IP address association with the newly created AMI (now added)
* Security Group association to open up port 22 and 80 for remote management (maybe via ansible/chef) and viewing, SSl port 443 will be added later on
* WP-CLI support to install plugins (will add to allow plugins to be installed via code) (Has now been added)

