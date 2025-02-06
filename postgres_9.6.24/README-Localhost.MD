#### Configuration & (Create - Drop) & (Backup - Restor)...
**<ins>Instal initdb**

    /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/data
    /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data >logfile 2>&1 &


### Start & Stop

**<ins>Start**

    /usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -l logfile start

 **<ins>Stop**  

    /usr/local/pgsql/bin/pg_ctl stop -D /usr/local/pgsql/data -m fast

### Network

    sudo nano /usr/local/pgsql/data/pg_hba.conf

**<ins>1- Edit & Add line IPv4**


    host     all     all     0.0.0.0/0     trust

**<ins>2- Edit & Change listen From Local To (*) and Remove (#)** 

    sudo nano /usr/local/pgsql/data/postgresql.conf
-

    listen_addresses = '*'     # Allow local connections
    #port = 5432                        # Default port
    #unix_socket_directories = '/tmp'   # Explicit socket directory

#### Create DB

    /usr/local/pgsql/bin/psql <db_name>

**<ins>Create with options (encoding, owner, etc.)**

    /usr/local/pgsql/bin/createdb <db_name> -E WIN1256 --lc-collate=C --lc-ctype=C --template=template0


#### Drop DB
   
     /usr/local/pgsql/bin/createdb <db_name>

#### <ins> Backup & Restor

**Copy DB-Backup-File From (Backup File Server) To (DB - Server)**

    scp /local/path/to/dumpfile.sql <db_user>@<db_ip>:/remote/path/to/dumpfile.sql

#### -1 Backup

    /usr/local/pgsql/bin/psql  pgsql -U <db_user> -d <db_name> -f <db_backup_name>.dump


#### -2 Restor


**<ins>Step 1: Create the Target Database .**

     /usr/local/pgsql/bin/createdb <db_name> -E WIN1256 --lc-collate=C --lc-ctype=C --template=template0



**Then**

**<ins>Step 2: Import the Dump**

    /usr/local/pgsql/bin/psql  pgsql -U pgsql -d <db_name> -f <db_name_backup_restor>

#### Command For Postgres

**Show All DB With out Join**

    psql -h <db_ip> -U <db_user> -l

**Display All Tabels In DB**

    psql -h <db_ip> -U <db_user> -d <db_name> -c "\dt"
