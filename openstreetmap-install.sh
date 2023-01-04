#!/bin/bash

# instaling GIS Utilities
sudo apt install -y osmium-tool
sudo apt-get install -y parallel pigz jq zip pbzip2
sudo apt-get install -y sqlite3 libsqlite3-dev libtiff-dev libcurl4-openssl-dev
sudo apt install -y golang-go
sudo apt-get install -y pspg

# Installing aria2 pyosmium (osm dump downloader)
sudo apt install -y aria2
sudo apt install -y pyosmium

# installing proj
sudo apt-get install -y proj-bin

# Install gdal
sudo apt-get install -y liblcms2-dev libtiff-dev libpng-dev libz-dev libjson-c-dev libpq-dev libgdal30 python3-gdal libgeotiff-dev liblz4-dev liblcms2-dev 
sudo apt-get install -y gdal-bin

# Installing Postgres
sudo apt install -y postgresql postgresql-contrib
sudo systemctl start postgresql.service

## Create postgres user/group
groupadd -r postgres
useradd -r -g postgres --home-dir=/var/lib/postgresql --shell=/bin/bash postgres

# Installing PostGIS
sudo apt install -y autoconf libtool libpcre3-dev libxml2-dev libgeos-dev libprotobuf-c-dev protobuf-c-compiler xsltproc docbook-xsl libgdal-dev
pg_version="$(psql -V | cut -d " " -f 3 | cut -d "." -f 1)"
sudo apt install -y postgis postgresql-$pg_version-postgis-3
sudo apt-get install -y postgresql-$pg_version-postgis-3-scripts
sudo apt install -y postgresql-server-dev-$pg_version

# Installing pgxnclient
sudo apt install -y pgxnclient
## pgxn has to call pg_config, add PG binaries to PATH
## sudo echo 'export PATH=$PATH:/usr/local/pgsql/bin' >> /root/.bashrc

# Install H3 if not installed
if [ -d "/usr/lib/postgresql/$pg_version/lib/bitcode/h3/" ] && [ -e "/usr/lib/postgresql/$pg_version/lib/bitcode/h3.index.bc" ] && [ -e "/usr/lib/postgresql/$pg_version/lib/h3.so" ]
then
   echo "Skip h3 installation: h3 already installed"
else
   echo "h3 doesn't exist, run h3 installation"
   sudo pgxn install h3  
fi

# Ubuntu Postgres stuff
sudo apt install -y postgresql-common

## Reset locale variables in case they were modified
. /usr/share/postgresql-common/maintscripts-functions
set_system_locale

## Create cluster main if not exists and systemd service
if [ -d "/etc/postgresql/$pg_version/main" ]
then
   echo "Skip creation main cluster for postgres $pg_version:  cluster $pg_version main already exists"
else
   echo "$pg_version main doesn't exist, run cluster creation"
   sudo pg_createcluster $pg_version main
fi

## Comment out "states_temp_directory" parameter from config (not recognized by PG15)
sudo sed -i 's/stats_temp_directory/#stats_temp_directory/g' /etc/postgresql/$pg_version/main/postgresql.conf
