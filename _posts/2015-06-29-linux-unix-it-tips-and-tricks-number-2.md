---
layout: post
title: "Linux-Unix-IT Tips and Tricks #2"
modified: 2014-06-29 13:54:48 +0300
category: [howto]
tags: [linux,unix,sysadm]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---
Different Linux / Unix / IT tips, notes, howto part 2

<section id="table-of-contents" class="toc">
<header>
<h3>Contents</h3>
</header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section><!-- /#table-of-contents -->

### MySQL log rotate
{% highlight bash %}
/etc/logrotate.d/mysql
/logs/mysql/mysql /logs/mysql/mysql.err /logs/mysql/mysql-slow.log /logs/mysql/query.log {
        notifempty
        daily
        rotate 7
        missingok
        compress
        sharedscripts
        postrotate
        # just if mysqld is really running
        if test -x /usr/bin/mysqladmin && \
           /usr/bin/mysqladmin ping &>/dev/null
        then
           /usr/bin/mysqladmin flush-logs
        fi
    endscript
}
{% endhighlight %}

### MySQL dump with procedures/functions/triggers
{% highlight bash %}
mysqldump --routines --no-create-info --no-data --no-create-db --skip-opt <database> > outputfile.sql
mysql <database> < outputfile.sql
{% endhighlight %}

### Show last login history
{% highlight bash %}
last -f  /var/log/wtmp.0
 -f file  Specifies a file to search other than /var/log/wtmp.
{% endhighlight %}

### Enable PostgreSQL Vacuum
{% highlight bash %}
vacuum full VERBOSE analyze;
{% endhighlight %}

### Create GEO DB for nginx
{% highlight bash %}
For use by the ngx_http_geo_module
wget http://geolite.maxmind.com/download/geoip/database/GeoIPCountryCSV.zip
unzip GeoIPCountryCSV.zip
wget https://raw.githubusercontent.com/simplegeo/nginx/master/contrib/geo2nginx.pl
perl geo2nginx.pl < GeoIPCountryWhois.csv > geo.conf
{% endhighlight %}

### Connect to COM port from FreeBSD or Linux
{% highlight bash %}
FreeBSD:
tip -vs9600 com1
to disconnect  shift+~~+.

or
cu -l /dev/cuau0 -s9600

Linux:
minicom -s
/dev/ttyS0
9600 8N1
sudo -u root minicom -s
{% endhighlight %}

### Upload IOS to Cisco router\switch from CentOS tftp
{% highlight bash %}
centos# yum -y install tftp-server tftp
centos# /etc/xinetd.d/tftp
disable = no
centos# service xinetd start

switch# copy tftp: flash:
switch# dir flash:
switch#show boot
switch# configure terminal
switch# (config)#boot system flash:c3550-i5q3l2-mz.121-13.
{% endhighlight %}

### Enable SSH on Cisco 2960 switch
{% highlight bash %}
You IOS must support K9, ex c2960s-universalk9-mz.122-55.SE3.bin

conf t
ip domain-name domain.com
crypto key generate rsa

line vty 0 4
transport input ssh
exec-timeout 0 0
{% endhighlight %}

### Restore Cisco password
{% highlight bash %}
Connect COM port
Reboot router and wait «Self decompressing the image: » press Ctrl-C or Ctrl-Break
confreg 0x2142(default -  2102)
reload
copy start run
make change with config
config-register 0x2102
reload
{% endhighlight %}

### Boot CentOS in a Single-User Mode
{% highlight bash %}
add to grub line that start with kernel - single
or 
init=/bin/sh
{% endhighlight %}

### Delete MySQL binary logs
{% highlight bash %}
/etc/my.cnf
expire_logs_days = 7
PURGE BINARY LOGS TO 'mysqld-bin.000123';
{% endhighlight %}

### Show memory map of a process
{% highlight bash %}
pmap PID
{% endhighlight %}

### Show all packages files in CentOS
{% highlight bash %}
for i in `rpm -qa`; do echo $i; rpm -ql $i; done
{% endhighlight %}

### Find duplicate files in Linux
{% highlight bash %}
for i in `find *`; do [ -f "$i" ] && echo "`md5sum \"$i\"`"; done | sort | awk -- '{ if (LAST==$1) print; else LAST=$1 }
or 
find /dir -type f -print0 | xargs -0 md5sum | sort | uniq -w32 -D # |awk '{print $2}'
{% endhighlight %}

### SSH+SVN error 
{% highlight bash %}
ssh svn: Network connection closed unexpectedly
This mean that you dont have sshkey fingerprint in know_hosts
try ssh to server first
{% endhighlight %}

### Kill all long MySQL request
{% highlight bash %}
mysql -e 'show full processlist'|grep -v Command |awk '{if ($6 >= 10) print "kill " $1 ";"}' |mysql
{% endhighlight %}

### Check LAST_ACK
{% highlight bash %}
LAST_ACK - mean that remote host is disconnected and socker is closed, we are waiting acknowledgment

sysctl -a |grep last_ack
net.ipv4.netfilter.ip_conntrack_tcp_timeout_last_ack = 30
sysctl -w net.ipv4.netfilter.ip_conntrack_tcp_timeout_last_ack=10
netstat -ant | fgrep ":" | cut -b 77-90 | sort | uniq -c

cat /proc/sys/net/netfilter/nf_conntrack_count
cat /proc/sys/net/ipv4/netfilter/ip_conntrack_count
cat /proc/sys/net/ipv4/ip_conntrack_max
echo 131072 > /proc/sys/net/ipv4/ip_conntrack_max
sysctl net.ipv4.netfilter.ip_conntrack_max=1048576

or disable conntrack for port

iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables -t raw -A PREROUTING -p tcp --dport 443 -j NOTRACK
{% endhighlight %}

### SYN flood protection
{% highlight bash %}
echo "20000" > /proc/sys/net/ipv4/tcp_max_syn_backlog
echo "1" > /proc/sys/net/ipv4/tcp_synack_retries
echo "30" > /proc/sys/net/ipv4/tcp_fin_timeout
echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes
echo "15" > /proc/sys/net/ipv4/tcp_keepalive_intvl
echo "20000" > /proc/sys/net/core/netdev_max_backlog
echo "20000" > /proc/sys/net/core/somaxconn

iptables -N syn_flood
$IPT -A INPUT -p tcp --syn -j syn_flood
$IPT -A syn_flood -m limit --limit 500/s --limit-burst 1500 -j RETURN
$IPT -A syn_flood -j DROP
{% endhighlight %}

### MegaCli on FreeBSD
{% highlight bash %}
Install linux compat from ports
mkdir -p /usr/compat/linux/proc
linsys          /compat/linux/sys       linsysfs        rw 0 0
linproc         /compat/linux/proc      linprocfs       rw 0 0
mount linsys
mount linproc
MegaCli -CfgDsply -a0
{% endhighlight %}

### Convert MySQL db from cp1251 to Utf8
{% highlight bash %}
mysqldump --default-character-set=utf8 database > database.utf8.sql
mysql --default-character-set=utf8 database_new < database.utf8.sql

or
mysqldump -u admin --password=PASS --opt --default-character-set=latin1 --skip-set-charset -Q DB_NAME > database.sql
sed -i 's/character set cp1251 collate cp1251_bin/character set utf8 collate utf8_bin/' database.sql
sed -i 's/CHARSET=cp1251/CHARSET=utf8/' database.sql
{% endhighlight %}

### Insert text in the top of file
{% highlight bash %}
perl -i~ -0777pe's/^/New first line\n/' yourfile
{% endhighlight %}

### IPMI in Linux of FreeBSD
{% highlight bash %}
Linux
yum install OpenIPMI OpenIPMI-tools
http://www.openfusion.net/linux/ipmi_on_centos
/sbin/modprobe ipmi_devintf; /sbin/modprobe ipmi_si; /sbin/modprobe ipmi_msghandler
# Logging
ipmitool sel info
ipmitool sel list

FreeBSD
# kldload ipmi
# dmesg | tail
ipmi0:  on isa0
ipmi0: KCS mode found at io 0xca2 alignment 0x1 on isa
ipmi0: IPMI device rev. 1, firmware rev. 0.2, version 2.0
ipmi0: Number of channels 2
ipmi0: Attached watchdog

# ipmitool chassis status
System Power         : on
Power Overload       : false
Power Interlock      : inactive
Main Power Fault     : false
Power Control Fault  : false
Power Restore Policy : always-on
Last Power Event     : command
{% endhighlight %}

### Disable NginX\Apache server token
{% highlight bash %}
NginX
server_tokens off

Apache
ServerTokens ProductOnly
ServerSignature Off
{% endhighlight %}

### Show installed perl modules
{% highlight bash %}
perl -MFile::Find=find -MFile::Spec::Functions -Tlwe \
'find { wanted => sub { print canonpath $_ if /\.pm\z/ }, no_chdir => 1 }, @INC'
{% endhighlight %}

### Use strace\lsof
{% highlight bash %}
strace -e trace=network -p PID
strace $(pidof httpd |sed 's/\([0-9]*\)/\-p \1/g')

lsof -nPp PID
lsof -a -U -u username
lsof -F pcfn
lsof +d /mnt/DIR
lsof +D /mnt/DIR
lsof -i [46][protocol][@hostname|hostaddr][:service|port]
{% endhighlight %}

### Create Patch
{% highlight bash %}
diff -crB tmpl_lib.c.orig tmpl_lib.c > tmpl_lib.patchс
patch -p1 -i tmpl_lib.patch
{% endhighlight %}

### Create gstripe in FreeBSD
{% highlight bash %}
kldload geom_stripe
sysctl kern.geom.debugflags=16
gstripe lable -v st0 /dev/da1 /dev/da2 /dev/da3 /dev/da4 /dev/da5
gstripe create -v st0 /dev/da1 /dev/da2 /dev/da3 /dev/da4 /dev/da5
bsdlabel -wB /dev/stripe/st0
newfs -O 2 -U /dev/stripe/st0a
mount /dev/stripe/st0a /www

echo 'geom_stripe_load="YES"' >> /boot/loader.conf

/etc/fstab
/dev/stripe/st0a       /www           ufs     rw,noatime              2       2

tunefs -m 1 /dev/stripe/st0a
{% endhighlight %}

### Delete trailing spaces in text with VIM
{% highlight bash %}
:%s/\s\+$//
delete blank lines
:g/^$/d 
{% endhighlight %}

### Disable Apache dir listing
{% highlight bash %}
<Directory />
    Options -Indexes
    AllowOverride all
    Order allow,deny
    Allow from all
</Directory>
{% endhighlight %}

### MySQL load data grant
{% highlight bash %}
grant file on *.* to user@localhost identified by 'P@ssw0rd';
{% endhighlight %}

### MySQL grants for fields in table
{% highlight bash %}
GRANT SELECT (col1), INSERT (col1,col2) ON mydb.mytbl TO 'someuser'@'somehost';
{% endhighlight %}

### Determine MAX MTU
{% highlight bash %}
ping ya.ru -v -M dont -s 1472 -W 1
{% endhighlight %}

### Upgrade CentOS Password Hashing
{% highlight bash %}
authconfig --test | grep hashing
authconfig --passalgo=sha512 --update
{% endhighlight %}

### Linux Pkg search 
{% highlight bash %}
http://pkgs.org/
{% endhighlight %}

### Run echo cmd with sudo
{% highlight bash %}
for i in server;do echo $i; echo 'echo ""' >  /logs/test.log'|ssh $i sudo sh;done
{% endhighlight %}

### Change percentage of root FS
{% highlight bash %}
tune2fs -m 0 /dev/sdc1
{% endhighlight %}

### Disable Ipv6 on CentOS
{% highlight bash %}
echo "alias net-pf-10 off" >/etc/modprobe.conf
echo "alias ipv6 off" >>/etc/modprobe.conf
chkconfig ip6tables off
sed -i 's/NETWORKING_IPV6=yes/NETWORKING_IPV6=no/g' /etc/sysconfig/network
reboot
{% endhighlight %}

### Fix chmod -x chmod
{% highlight bash %}
perl -e 'chmod 0755, "/bin/chmod"'
python -c 'import os; os.chmod("chmod", 0755)'

or 

cp /bin/sh ~/chmod2
cat /bin/chmod > ~/chmod2
sudo ~/chmod2 +x /bin/chmod
rm ~/chmod2

or 

sudo apt-get --reinstall install `dpkg -S /bin/chmod | cut -f1 -d:`

gcc -x c - <<CHMOD
#include <sys/stat.h>
main(){chmod("/bin/chmod", S_IXUSR | S_IXGRP | S_IXOTH);}
CHMOD
sudo ./a.out
rm a.out

or

/lib/ld-linux-x86-64.so.2 /bin/chown +x /bin/chown
{% endhighlight %}

### Get webserver http code answer 
{% highlight bash %}
wget --server-response -T 5 -t 1 http://ya.ru 2>&1 | awk '/^  HTTP/{print $2}'
{% endhighlight %}

### Clone disk with DD by network
{% highlight bash %}
dd if=/dev/sdd1 bs=1M | ssh -c arcfour user@server "dd of=/dev/sdf1 bs=1M" ; echo "dd of disk1@server1 is finished" | mail -s "DD_CLONE" adm@server.net

disk with errors
dd if=/dev/sdd1 bs=1M conv=sync,noerror | ssh -c arcfour user@server "dd of=/dev/sdd1 bs=1M"

use nc
dd if=/dev/sde1 bs=1M | nc newserver 7000
nc -l 7000 | dd of=/dev/sde1 bs=1M
{% endhighlight %}

### SSH x11 forwarding
{% highlight bash %}
yum install xorg-x11-xauth
apt-get install xauth
ssh -X
{% endhighlight %}

### Extract RPM pkg
{% highlight bash %}
rpm2cpio myrpmfile.rpm | cpio -idmv
{% endhighlight %}
