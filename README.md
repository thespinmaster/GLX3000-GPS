
# Router gps forwarding to the CerboGX

The following instructions are for enabling the forwarding of NMEA gps messages from 5G mobile cells without the need for a dedicated gps dongle. 

The messages are forwarded to a Victron CerboGX (or any device running the Venus OS)

## Hardware
GL-Net x3000 Spitz router (other OpenWRT routers may work)  
Victron Cerbo GX (or any device running the Venus OS)

## Router setup
Log into the routers web ui

Enable gpsd in the modems 5G settings

Open the cellular settings page …

Enter the following two AT Commands.
```
AT+QGPSCFG="autogps",1  
T+QGPS=1
```

SSH into the router

Update the package manager  
```opkg update```

Install socat  
socat is used as it will continue to work even when the Venus OS is rebooted.
Note the installed socat is a busybox cutdown verson, and does not work. 

```opkg install socat```

Check gpsd is working  
```cat /dev/mhi_LOOPBACK```
 
Should see NMEA messages being output every few seconds. Ctrl C to quit
```
$GPGSV,3,2,10,25,24,103,38,26,54,316,43,27,12,249,26,28,59,203,25,1*67
$GPGSV,3,3,10,29,40,045,28,31,65,260,31,1*66
$GPGSV,1,1,0,8*5D
$GPGGA,143653.00,3649.353448,N,00442.549153,W,1,08,0.4,194.6,M,47.8,M,,*7D
$PQXFI,143653.0,3649.353448,N,00442.549153,W,194.6,3.54,2.50,0.09*75
$GPVTG,,T,359.8,M,0.0,N,0.0,K,A*0A
$GPRMC,143653.00,A,3649.353448,N,00442.549153,W,0.0,,020225,0.2,E,A,V*78
$GPGSA,A,3,16,18,25,26,27,28,29,31,,,,,0.7,0.4,0.5,1*22
```

Useful decoder at:  https://rl.se/gprmc

## Install service

Download the install script from github  
```wget -O gpsdservice-install.sh https://raw.githubusercontent.com/thespinmaster/GLX3000-GPS/refs/heads/main/gpsdservice-install.sh```

Change the permissions and run the script  
```
chmod 755 gpsdservice-install.sh 
./gpsdservice-install.sh
```

Enter the ip address of the Venus OS when prompted. i.e. 192.168.32.20

The gpsd service file will download to /etc/init.d/gpsdservice  
The gpsd service config file will download to /etc/config/gpsdservice  

After which the script will enable and run the service.

Check the service is running.  
```service --status-all | grep 'gpsdservice'```

Stop/disable the service with  
```
/etc/init.d/gpsdservice stop
/etc/init.d/gpsdservice disable
```
Note you can also start, stop and enable the service from the luci UI

Update the ip address with
```
uci set gpsdservice.venus.ip=[ip address]
```

##Cerbo GX setup
In the Cerbo goto settings>>gps
You should see a new gps device listed
If it does not show, reboot.

