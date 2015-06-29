---
layout: post
title: "4G Huawei E392 with Linux"
modified: 2015-06-26 12:40:49 +0300
category: [howto]
tags: [linux,4gmodem,openwrt]
image:
  feature: 
  credit: 
  creditlink: 
comments: True
share: 
---
Working with 4G modem Huawei E392 in Linux and OpenWRT

### Ubuntu Linux

##### Install pkgs
{% highlight bash %}
apt-get install wvdial
wvdialconf
{% endhighlight %}

##### Add to /etc/wvdial.conf 
{% highlight bash %}
[Dialer Defaults]
Init1 = ATZ
Init2 = AT+CGDCONT=1,"IP","Internet"
Modem Type = USB Modem
Baud = 57600
New PPPD = yes
Modem = /dev/ttyUSB0
Phone = *99#
Password = \n 
Username = \n
Stupid Mode = yes
{% endhighlight %}

##### Auto Reconnect
{% highlight bash %}
#! /bin/bash
(
   while : ; do
       wvdial
       sleep 10
   done
) &
{% endhighlight %}

##### System network configuration
{% highlight bash %}
/etc/network/interfaces
auto ppp0
iface ppp0 inet wvdial
{% endhighlight %}


### OpenWRT Asus Wl600g

##### Links
- [wl600g](http://wiki.openwrt.org/toh/asus/wl600g)
- [basic.config](http://wiki.openwrt.org/doc/howto/basic.config)
- [ltedongle](http://wiki.openwrt.org/doc/recipes/ltedongle)
- [turn-your-old-wireless-router-into-lte](http://intelnuc.blogspot.ru/2014/10/turn-your-old-wireless-router-into-lte.html)

##### Download and Install
{% highlight bash %}
Load the image into your router via the web interface http://192.168.1.1 or tftp
wget http://downloads.openwrt.org/backfire/10.03.1/brcm63xx/openwrt-96348GW-generic-squashfs-cfe.bin
tftp -i 192.168.1.1 PUT openwrt-96348GW-generic-squashfs-cfe.bin
{% endhighlight %}

##### Enable SSH
{% highlight bash %}
Web -> System-Administration -> SSH Access -> Allow remote hosts to connect to local SSH forwarded ports
{% endhighlight %}

##### Install required packages
{% highlight bash %}
telnet\ssh 192.168.1.1
opkg update
opkg install kmod-mii kmod-usb-net kmod-usb-net-qmi-wwan kmod-usb-serial kmod-usb-serial-option kmod-usb-serial-wwan kmod-usb-wdm uqmi usb-modeswitch
reboot
{% endhighlight %}

##### Configuring modem with pppd
{% highlight bash %}
/etc/ppp/peers/megafon-3g
connect "chat -Vs -r /var/log/ppp -f /etc/chatscripts/megafon-3g"
460800
crtscts
modem
ttyUSB1
noauth
usepeerdns
defaultroute
user ""
password ""
logfile /var/log/ppp

and add to

/etc/chatscripts/megafon-3g
TIMEOUT 35
ECHO ON
ABORT '\nBUSY\r'
ABORT '\nERROR\r'
ABORT '\nNO ANSWER\r'
ABORT '\nNO CARRIER\r'
ABORT '\nNO DIALTONE\r'
ABORT '\nRINGING\r\n\r\nRINGING\r'
ABORT '\nUsername/pASSWORD Incorrect\r'
''  \rAT
OK  'AT+CGDCONT=1,"IP","Internet"'
OK  ATD*99#CONNECT  ""

Now you can run 
pppd call megafon-3g
{% endhighlight %}

##### Network configuration
{% highlight bash %}
/etc/config/network
config interface wan
        option ifname  ppp0 # on some carriers enable this line
        option device  /dev/ttyUSB1
        option apn     Internet
        option service umts
        option proto   3g

cp /etc/chatscripts/megafon-3g /etc/chatscripts/3g.chat

and now you can run:

ifup wan
{% endhighlight %}

##### Firewall configuration
{% highlight bash %}
go to Network → Firewall, scroll down to wan and click the Edit button
add a checkmark to the wwan box under Covered networks heading, click Save & Apply
{% endhighlight %}

##### Configuring modem on Barrier Breaker
{% highlight bash %}
This example will work only with modern openwrt like Barrier Breaker 14.07

root@OpenWrt:~# ls -l /dev/cdc-wdm0
root@OpenWrt:~# dmesg
root@OpenWrt:~# cat /sys/kernel/debug/usb/devices
root@OpenWrt:~# uqmi -d /dev/cdc-wdm0 --get-data-status
root@OpenWrt:~# uqmi -d /dev/cdc-wdm0 --get-signal-info
root@OpenWrt:~# uqmi -d /dev/cdc-wdm0 --start-network Internet --autoconnect
root@OpenWrt:~# uqmi -d /dev/cdc-wdm0 --get-data-status
{% endhighlight %}

##### Network configurationa on Barrier Breaker
{% highlight bash %}
add new Interface to /etc/config/network
config interface 'wwan'
option ifname 'wwan0'
option proto 'dhcp'
{% endhighlight %}
