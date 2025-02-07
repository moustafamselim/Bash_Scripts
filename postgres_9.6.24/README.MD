### <ins>Postgrsql_9.6.24 (Installation - Configuration - Create & Drop - Backup & Restor)

## <ins>Contents
- [Installation](#installation)
- [DB_Server_Configuration](#db_server_configuration)
- [Create & Drop_DB](#create--drop_db)
- [Backup & Restor](#backup--restor)
- [Command For Postgres](#command-for-postgres)
----
## Installation: 
**<ins>Update & Upgrade & Install Dependencies**

    sudo apt update && sudo apt upgrade -y
    ssudo apt install -y build-essential libreadline-dev zlib1g-dev flex bison \
     libxml2-dev libxslt1-dev libssl-dev libpam0g-dev libedit-dev

    
**<ins>Download postgres-9.6.24**

    wget https://ftp.postgresql.org/pub/source/v9.6.24/postgresql-9.6.24.tar.gz
    tar xfz postgresql-9.6.24.tar.gz
    cd postgresql-9.6.24

**<ins>Install PostgreSQL 9.6**

    ./configure
    make
    sudo make install

**<ins>Add Users**

    sudo adduser pgsql 

**<ins>Create Dirctory**

    sudo mkdir /usr/local/pgsql/data
    
**<ins>Change Owner Of Postgres_DB_Folder** 

    sudo chown pgsql /usr/local/pgsql/data
    sudo chown -R pgsql:pgsql /usr/local/pgsql/data

**<ins>Switch To Pgsql User :**

```
su pgsql
```

    /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
    /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data >logfile 2>&1 &
----

## DB_Server_Configuration
**<ins>The default is to be able to access the database locally and also to run the Database Service manually.....**

**<ins>We will modify it as follows:**
###  Start - Stop

**<ins>1- Manually with postgres user** 

**<ins>Start**

    /usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start

**<ins>Stop**
   
    /usr/local/pgsql/bin/pg_ctl stop -D /usr/local/pgsql/data -m fast


**<ins>2- Create File to Auto Start & Stop**


    sudo nano /etc/systemd/system/postgresql.service 

**<ins>Add & -- Note --: Please change the name of the Database Admin**
 

    [Unit]
    Description=PostgreSQL Database Server
    After=network.target

    [Service]
    Type=forking
    User=pgsql
    ExecStart=/usr/local/pgsql/bin/pg_ctl start -D /usr/local/pgsql/data
    ExecStop=/usr/local/pgsql/bin/pg_ctl stop -D /usr/local/pgsql/data
    Restart=on-failure

    [Install]
    WantedBy=multi-user.target 

**<ins>And Then....**

    sudo systemctl daemon-reload
    sudo systemctl enable postgresql
    sudo systemctl start postgresql
    sudo systemctl status postgresql

![Status]()


## - Network & Connection
**Config To Connect For Any Network**


**<ins>To Connect For Any Network**

    sudo nano /usr/local/pgsql/data/pg_hba.conf
**<ins>Edit & Add line**

    host     all     all     0.0.0.0/0     trust


![Pg_hba.conf]()

    sudo nano /usr/local/pgsql/data/postgresql.conf
**<ins>Edit & Change listen From Local To (*) and Remove (#)  

    listen_addresses = '*'     # Allow local connections
    #port = 5432                        # Default port
    #unix_socket_directories = '/tmp'   # Explicit socket directory

![Postgresql.conf]()



#### <ins>Connect To DB

**<ins>Localhost**

    psql -U <db_user> -h localhost -d <db_name>  

   OR

    /usr/local/pgsql/bin/psql <db_name>


**<ins>External**
 **<ins>Note: Database client must be installed .**
    
    sudo apt install postgresql-client

**<ins>Then**

    psql -U <db_user> -h <db_ip> -d <db_name> -p 5432

  OR

    psql postgresql://<db_user>:your_password@<db_ip>:5432/<db_name>


   ---

### Create & Drop_DB
   #### 1 - <ins>Create

    /usr/local/pgsql/bin/createdb <db_name>

OR

     psql -U <db_user> -h <db_ip> -p 5432 -d postgres -c "CREATE DATABASE <db_name>;"

**<ins>Create with options (encoding, owner, etc.)**

    /usr/local/pgsql/bin/createdb <db_name> -E WIN1256 --lc-collate=C --lc-ctype=C --template=template0

OR

    createdb -U <db_user> -h localhost -E UTF8 --owner=<your_user> <db_name>


#### 2 - <ins>Drop

    /usr/local/pgsql/bin/dropdb <db-name>
    
OR

    dropdb -U <db_user> -h localhost <db_name>

   OR

    dropdb -U <db_user> -h localhost --force <db_name>

----

### Backup & Restor

**<ins>Backup**

    /usr/local/pgsql/bin/psql  pgsql -U <db_user> -d <db_name> -f <db_backup_name>.dump

OR

    pg_dump -U <db_user> -h <db_ip> -d <db_name> -p 5432 -F p -f <db_backup_name>.dump

OR

    pg_dump -U <db_user> -h <db_ip> -d <db_name> -p 5432 -Fc -Z 9 -f <db_backup_name>.dump


**<ins>Restor**

**<ins>Step 1: Create the Target Database .**

     psql -U <db_user> -h <db_ip> -p 5432 -d postgres -c "CREATE DATABASE <db_name>;"



**Then**

**<ins>Step 2: Import the Dump**

    /usr/local/pgsql/bin/psql  pgsql -U pgsql -d <db_name> -f <db_name_backup_restor>

**<ins>Import db via ssh**

    scp /local/path/to/dumpfile.sql <db_user>@<db_ip>:/remote/path/to/dumpfile.sql


![Restor]()


### Command For Postgres

**Show All DB With out Join**

    psql -h <db_ip> -U <db_user> -l

**Display All Tabels In DB**

    psql -h <db_ip> -U <db_user> -d <db_name> -c "\dt"



































