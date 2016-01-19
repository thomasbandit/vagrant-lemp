# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# A basic LEMP Vagrant box using Vaprobash shell scripts for quick provisioning
#

# Config Github Settings
github_username = "fideloper"
github_repo     = "Vaprobash"
github_branch   = "1.4.2"
github_url      = "https://raw.githubusercontent.com/#{github_username}/#{github_repo}/#{github_branch}"

# Because this:https://developer.github.com/changes/2014-12-08-removing-authorizations-token/
# https://github.com/settings/tokens
github_pat          = ""


public_folder         = "/var/www"

# Set a local private network IP address.
# See http://en.wikipedia.org/wiki/Private_network for explanation
# You can use the following IP ranges:
#   10.0.0.1    - 10.255.255.254
#   172.16.0.1  - 172.31.255.254
#   192.168.0.1 - 192.168.255.254
server_ip             = "192.168.56.147"
server_cpus           = "3"   # Cores
server_memory         = "1536" # MB
server_swap           = "3072" # Options: false | int (MB) - Guideline: Between one or two times the server_memory

# Server Configuration
hostname        = "superinteractive.dev"

# UTC        for Universal Coordinated Time
# EST        for Eastern Standard Time
# CET        for Central European Time
# US/Central for American Central
# US/Eastern for American Eastern
server_timezone  = "UTC"

# Database Configuration
mysql_root_password   = "root"   # We'll assume user "root"
mysql_version         = "5.5"    # Options: 5.5 | 5.6
mysql_enable_remote   = "false"  # remote access enabled when true
pgsql_root_password   = "root"   # We'll assume user "root"
mongo_version         = "2.6"    # Options: 2.6 | 3.0
mongo_enable_remote   = "false"  # remote access enabled when true

# Languages and Packages
php_timezone          = "UTC"    # http://php.net/manual/en/timezones.php
php_version           = "5.6"    # Options: 5.5 | 5.6
ruby_version          = "latest" # Choose what ruby version should be installed (will also be the default version)

# List any Ruby Gems that you want to install
ruby_gems             = []

nodejs_version        = "latest"
nodejs_packages       = []


# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "ubuntu/trusty64"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 8952

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: server_ip

  # Create a hostname, don't forget to put it to the `hosts` file
  # This will point to the server's default virtual host
  config.vm.hostname = hostname

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  config.vm.synced_folder "/Users/thomas/www/super", "/mnt/vagrant-superenv201601", type: 'nfs', mount_options: ['actimeo=2']
  config.bindfs.bind_folder "/mnt/vagrant-superenv201601", public_folder, owner: "vagrant", group: "www-data", perms: "u=rwX:g=rwX:o=rD"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    #vb.gui = true
 
    # Customize the amount of memory on the VM:
    vb.memory = server_memory
    vb.cpus = server_cpus
  end


  ##########
  # PROVISION SCRIPTS
  ##########

  # Provision Base Packages
  config.vm.provision "shell", path: "#{github_url}/scripts/base.sh", args: [github_url, server_swap, server_timezone]

  # optimize base box
  config.vm.provision "shell", path: "#{github_url}/scripts/base_box_optimizations.sh", privileged: true

  # Provision PHP (2nd argument is bool for HHVM)
  config.vm.provision "shell", path: "#{github_url}/scripts/php.sh", args: [php_timezone, "false", php_version]

  # Provision Nginx Base
  config.vm.provision "shell", path: "#{github_url}/scripts/nginx.sh", args: [server_ip, public_folder, hostname, github_url]

  # Provision MySQL
  config.vm.provision "shell", path: "#{github_url}/scripts/mysql.sh", args: [mysql_root_password, mysql_version, mysql_enable_remote]

  # Install Elasticsearch
  config.vm.provision "shell", path: "#{github_url}/scripts/elasticsearch.sh"

  # Install ElasticHQ - Admin for: Elasticsearch
  config.vm.provision "shell", path: "#{github_url}/scripts/elastichq.sh"

  # Install Nodejs
  config.vm.provision "shell", path: "#{github_url}/scripts/nodejs.sh", privileged: false, args: nodejs_packages.unshift(nodejs_version, github_url)

  # Provision Composer
  config.vm.provision "shell", path: "#{github_url}/scripts/composer.sh", privileged: false, args: [github_pat, composer_packages.join(" ")]

  # Install Mailcatcher
  config.vm.provision "shell", path: "#{github_url}/scripts/mailcatcher.sh"
end
