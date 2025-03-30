
# Router gps forwarding to the CerboGX

The following instructions are for enabling the forwarding of NMEA gps messages from 5G mobile cells without the need for a dedicated gps dongle. 

The messages are forwarded to a Victron CerboGX

## Hardware
GL-Net x3000 Spitz router  
Victron Cerbo GX

## Router setup
Log into the routers web ui

First enable gpsd in the 5G modem settings

Open the cellular settings page …

Enter the following two AT Commands.
```
AT+QGPSCFG="autogps",1  
T+QGPS=1
```

SSH into the router

Update the package manager  
``opkg update``

(Optional)
Install nano package  
``opkg install nano``

Install socat
socat is used as it will continue to work even when the CerboGX is rebooted.
Note the installed socat is a busybox cutdown verson, and foes not work  

``opkg install socat``

Check gpsd is working  
``cat /dev/mhi_LOOPBACK``
 
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

Create a script file used to forward the NMEA messages to the CerboGX
future note, might be able to put the socat call directly inside the 
gpsdservice file further down, eliminating the need for this file  
``nano /etc/gpsd-daemon.sh``

Enter the following and save. changing the IP address to the address of the CerboGX
```
#!/bin/sh..  

#using udp4-datagram as this survives cerbo gx reboots. 
socat -u /dev/mhi_LOOPBACK udp4-datagram:192.168.10.20:8500
```

Make the script executable  
``chmod 755 /etc/gpsd-daemon.sh``

Create the service  
``nano /etc/init.d/gpsdservice``

Enter the following and save
```
#!/bin/sh /etc/rc.common.

USE_PROCD=1
START=99
STOP=01

CONFIGURATION=gpsdservice

start_service() {
  # Reading config
  config_load "${CONFIGURATION}"
  local IP
 
  config_get IP venus IP
  
	procd_open_instance
	procd_set_param command socat
	procd_append_param -u /dev/mhi_LOOPBACK udp4-datagram:$IP # append command parameters
	procd_close_instance
}

```

Mark the file as executable  
``chmod 755 /etc/init.d/gpsdservice``

Enable and start the service
```
/etc/init.d/gpsdservice enable
/etc/init.d/gpsdservice start
```
Note you can also start, stop and enable the service from the luci UI

Check service status with  
``service --status-all | grep 'gpsdservice'``

##Cerbo GX setup
In the Cerbo goto settings>>gps
You should see a new gps device listed
If it does not show, reboot.



#Todo
See if the gpsd-daemon.sh can be removed
See if it survives a router firmware update, fix as appropriate.
Possibly use uci config to configure the service ip address
Plugin for the router ui. Is there an API for this?
