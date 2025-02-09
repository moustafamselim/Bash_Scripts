#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential libreadline-dev zlib1g-dev flex bison \
     libxml2-dev libxslt1-dev libssl-dev libpam0g-dev libedit-dev

#Download postgres-9.6.24
wget https://ftp.postgresql.org/pub/source/v9.6.24/postgresql-9.6.24.tar.gz
tar xfz postgresql-9.6.24.tar.gz
cd postgresql-9.6.24

#Install PostgreSQL 9.6
./configure
make
sudo make install

#Add Users
sudo adduser pgsql 

#Create Dirctory
sudo mkdir /usr/local/pgsql/data

#Change Owner Of Postgres_DB_Folder

sudo chown pgsql /usr/local/pgsql/data
sudo chown -R pgsql:pgsql /usr/local/pgsql/data

#Switch To Pgsql User

su pgsql

# Continue installation README File

#when install postgres 9.6.24
psql
