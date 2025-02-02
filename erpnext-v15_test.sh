#!/bin/bash

echo "#// Pre-requisites //  #########################################################################################################

  #Python 3.12+                                  (python 3.12 is inbuilt in 24.04 LTS)
  #Node.js 18+
  #Redis 5                                       (caching and real time updates)
  #MariaDB 10.3.x / Postgres 9.5.x               (to run database driven apps)
  #yarn 1.12+                                    (js dependency manager)
  #pip 20+                                       (py dependency manager)
  #wkhtmltopdf (version 0.12.5 with patched qt)  (for pdf generation)
  #cron                                          (bench's scheduled jobs: automated certificate renewal, scheduled backups)
  #NGINX                                         (proxying multitenant sites in production)
############################################################################################################################ " 

#install update
sudo apt-get update -y
sudo apt-get upgrade -y

#install necessary packages
sudo apt-get install git
sudo apt-get install python3-dev python3.12-dev python3-setuptools python3-pip -y
sudo apt-get install python3.12-venv -y
sudo apt-get install software-properties-common
sudo apt install mariadb-server mariadb-client -y
sudo apt-get install redis-server -y
sudo apt-get install xvfb libfontconfig wkhtmltopdf -y
sudo apt-get install libmysqlclient-dev -y

############################################################################
sudo mysql_secure_installation          # // root password must chnage
################################

#######################################################     // Copy 
echo "
[mysqld]
character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci

[mysql]
default-character-set = utf8mb4 "| sudo tee -a /etc/mysql/my.cnf

########################################################
sudo service mysql restart
##################################

#install curl
sudo apt install curl
curl https://raw.githubusercontent.com/creationix/nvm/master/install.sh | bash
source ~/.profile
nvm install 18

################
#install npm - yarn - supervisor
sudo apt-get install npm -y
sudo npm install -g yarn
sudo apt install -y supervisor

#install frappe-bench
echo "install frappe-bench"
sleep 5
sudo pip3 install frappe-bench --break-system-packages
bench init --frappe-branch version-15 frappe-bench
 
# install erpnext in site
cd frappe-bench
chmod -R o+rx /home/frappe

#############################################   // site - production
bench new-site site.local  
bench get-app --branch version-15 erpnext
bench --site site.local install-app erpnext
bench --site site.local enable-scheduler
bench --site site.local set-maintenance-mode off
#####################################################  // site - Staging
bench new-site site.test
bench --site site.test install-app erpnext
bench --site site.test enable-scheduler
bench --site site.test set-maintenance-mode off
######################################################

bench setup supervisor
sudo supervisorctl reread
sudo supervisorctl update
sudo supervisorctl start all
sudo systemctl enable supervisor


#Install Python Virtual Environment
sudo apt install python3-venv
python3 -m venv env
sudo /usr/bin/python3 -m pip install ansible --break-system-packages

echo "Final -----"
sudo apt install fail2ban -y
sudo apt update
sudo apt install nginx -y
sudo bench setup production frappe

#config ports (sites)
nano /etc/nginx/conf.d/frappe-bench.conf                              # // Change Ports to ( 8070 - 8071 ) 
sudo service nginx reload 





## create user in database

## mysql -u root -p

## CREATE USER 'matthew'@'%' IDENTIFIED BY 'supersecretpassword';

##  GRANT ALL PRIVILEGES ON * . * TO 'matthew'@'%';

##  FLUSH PRIVILEGES;

##  SELECT user FROM mysql.user;     // ## Show all user in data base
## SELECT user,host FROM mysql.user;  //Show all user & host

## DROP USER 'minal'@localhost;     // DROP USER 


#Edit

#sudo nano /etc/mysql/mariadb.conf.d/50-server.cnf                 # // Add 0.0.0.0
#sudo systemctl restart mysql


