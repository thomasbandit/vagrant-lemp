#!/bin/bash
#
#  Usage: $ sudo ./add-vhost.sh sitename.com /var/www/dir [type] [IP]
#
# [type] = php OR spa
# [IP]   = The public IP of the Vagrantbox
# 
# e.g. sudo sh ./add-vhost.sh loc.jedlix.com /var/www/loc.jedlix.com/app/build/ php 192.168.56.147
#

RED_COLOR='\033[0;31m'
GREEN_COLOR='\033[0;32m'
NO_COLOR='\033[0m'

SERVER_NAME="$1"
WWW_PATH="$2"
TYPE="$3"
VAGRANT_IP="$4"

# Exit and return error if type argument was not set
if [ "$TYPE" != "php" ] && [ "$TYPE" != "spa" ] ; then
  printf "${RED_COLOR}Error! The type attribute must be either 'php' or 'spa'.\n${NO_COLOR}"
  exit 1
fi;

echo "Creating a vhost for $SERVER_NAME. Directory: $ROOT_PATH"

# Get the relevant vhost template
if [ "$TYPE" = "php" ] ; then
  sudo cp /vagrant/helpers/nginx-templates/template-php.conf /etc/nginx/sites-available/$SERVER_NAME.conf
else : 
  sudo cp /vagrant/helpers/nginx-templates/template-spa.conf /etc/nginx/sites-available/$SERVER_NAME.conf
fi;

# Replace the keyword variables
sudo sed -i 's/%server_name%/'$SERVER_NAME'/g' /etc/nginx/sites-available/$SERVER_NAME.conf
sudo sed -i 's#%www_path%#'$WWW_PATH'#g' /etc/nginx/sites-available/$SERVER_NAME.conf
sudo sed -i 's/%vagrant_ip%/'$VAGRANT_IP'/g' /etc/nginx/sites-available/$SERVER_NAME.conf

# Activate the nginx vhost by setting up a symlink and reload the service
sudo ln -s /etc/nginx/sites-available/$SERVER_NAME.conf /etc/nginx/sites-enabled/
sudo service nginx reload

# Add to Vagrant box hosts
echo "127.0.1.1 ${SERVER_NAME}" >> /etc/hosts

printf "${GREEN_COLOR}Success! ${NO_COLOR}Vhost for $SERVER_NAME configured and nginx reloaded.\n"
