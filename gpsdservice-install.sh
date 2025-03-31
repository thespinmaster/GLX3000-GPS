 
source="https://raw.githubusercontent.com/thespinmaster/GLX3000-GPS/refs/heads/main/"

wget -O /etc/init.d/gpsdservice $source + gpsdservice

#download service config
wget -O /etc/config/gpsdservice $source + gpsdservice-config
