#!/bin/sh
 
echo Enter the IP address of the Venus OS
read ip

if [[-z "$ip"]]; then
  echo "no ip address"
  exit
fi

source="https://raw.githubusercontent.com/thespinmaster/GLX3000-GPS/refs/heads/main"

#download gsddservice
wget -O "/etc/init.d/gpsdservice" "${source}/gpsdservice"

#download service config
wget -O "/etc/config/gpsdservice" "${source}/gpsdservice-config"

echo change the permissions for the service
chmod 755 /etc/init.d/gpsdservice

echo update the config ip to: $ip
uci set gpsdservice.venus.ip=$ip
uci commit gpsdservice

echo enable and start the service
/etc/init.d/gpsdservice enable
/etc/init.d/gpsdservice start


