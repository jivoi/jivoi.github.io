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
Reboot router and wait «Self decompressing the image: ###» press Ctrl-C or Ctrl-Break
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
