#!/bin/sh
 
echo Enter the IP address of the Venus OS
read ip

source="https://raw.githubusercontent.com/thespinmaster/GLX3000-GPS/refs/heads/main/"

#download gsddservice
wget -O /etc/init.d/gpsdservice $source + "gpsdservice"

#download service config
wget -O /etc/config/gpsdservice $source + "gpsdservice-config"

#change the permissions for the service
chmod 755 /etc/init.d/gpsdservice

#update the config ip to the one inputed earlier
uci set gpsdservice.venus.ip=$ip

#enable and start the service
/etc/init.d/gpsdservice enable
/etc/init.d/gpsdservice start


