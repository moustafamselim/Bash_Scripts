#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install build-essential libreadline-dev zlib1g-dev flex bison git -y
sudo apt-get install make -y
sudo apt-get install gcc -y
sudo apt-get install zlib1g-dev -y
sudo apt-get install bison -y

#Download postgres
wget https://ftp.postgresql.org/pub/source/v9.6.24/postgresql-9.6.24.tar.gz
tar xfz postgresql-9.6.24.tar.gz
cd postgresql-9.6.24

#Installation
./configure
make
sudo make install
sudo adduser postgres
sudo mkdir /usr/local/pgsql/data


sudo chown postgres /usr/local/pgsql/data
sudo chown -R postgres:postgres /usr/local/pgsql/data

su - postgres

/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data >logfile 2>&1 &
/usr/local/pgsql/bin/createdb test
