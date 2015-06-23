---
layout: post
title: "Linux-Unix-IT Tips and Tricks #1"
modified: 2014-06-22 13:54:48 +0300
category: [howto]
tags: [linux,unix,sysadm]
image:
  feature: 
  credit: 
  creditlink: 
comments: True
share: 
---
Different Linux / Unix / IT tips, notes, howto

<section id="table-of-contents" class="toc">
<header>
<h3>Contents</h3>
</header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section><!-- /#table-of-contents -->

{% highlight bash %}
{% endhighlight %}

### Phpinfo
{% highlight bash %}
echo "<?php phpinfo(); ?>" > file
root@linux: ~ # php -i
{% endhighlight %}

### Apache VirtualHost
{% highlight bash %}
<Directory ~ ".*\.svn">
    Order allow,deny
    Deny from all
    Satisfy All
</Directory>

<VirtualHost 127.0.0.1:80>
    ServerName vhost1
    ErrorLog /logs/vhost1/error_log
    DocumentRoot /www/vhost1/htdocs
    <Directory /www/vhost1/htdocs>
		AllowOverride All
    </Directory>
</VirtualHost>
{% endhighlight %}

### Grant all access to MySQL DB
{% highlight bash %}
grant all privileges on user.* to user@"%" identified by "P@ssw0rd";
{% endhighlight %}

### Check disk with DD
{% highlight bash %}
dd if=/dev/da0 of=/dev/null bs8
for progress Ctrl+T to send USR1 or kill -USR1 DDPID
{% endhighlight %}

### Manual install php extensions
{% highlight bash %}
${PHP_PREFIX}/bin/pecl uninstall memcache
${PHP_PREFIX}/bin/pecl install memcache

add to php.ini
extension=memcache

Build extension from source
wget memcache-2.2.5.tgz
/usr/local/php/bin/phpize
./configure --with-php-config=/usr/local/php/bin/php-config
{% endhighlight %}

### Create MySQL DB
{% highlight bash %}
CREATE DATABASE TEST default charset utf8;
grant all on testuser.*  to 'testuser'@'SOMEIP' identified by 'P@ssw0rd';
{% endhighlight %}

### Update user grants for MySQL DB
{% highlight bash %}
update user set password=PASSWORD('P@ssw0rd') where user='testuser';
show grants for 'testuser'@'SOMEIP';
revoke all on TEST.*  from 'testuser'@'SOMEIP';
{% endhighlight %}

### Skip MySQL DB Replication error
{% highlight bash %}
show slave status;
SET GLOBAL SQL_SLAVE_SKIP_COUNTER = N;
{% endhighlight %}

### Simple MySQL DB backup\restore commands
{% highlight bash %}
Backup all db server
mysqldump --master-data=2 --opt --single-transaction --all-databases | gzip -9 -c > /www/backup/`hostname`.`date +%Y%m%d`.sql.gz

Backup only tables
mysqldump test --tables tag_table > /backup/test.tag_table.sql
mysqldump -u USER -pPASSWORD DATABASE TABLE1 TABLE2 TABLE3 > /path/to/file/dump_table.sql

Backup one database
mysqldump -u USER -pPASSWORD DATABASE > /path/to/file/dump.sql
mysqldump -u USER -pPASSWORD DATABASE | gzip > /path/to/outputfile.sql.gz
mysqldump -u USER -pPASSWORD DATABASE | gzip > `date +/path/to/outputfile.sql.%Y%m%d.%H%M%S.gz` 

Backup database scheme
mysqldump --no-data - u USER -pPASSWORD DATABASE > /path/to/file/schema.sql

Restore database
mysql -u USER -pPASSWORD DATABASE < /path/to/dump.sql
gunzip < /path/to/outputfile.sql.gz | mysql -u USER -pPASSWORD DATABASE
zcat /path/to/outputfile.sql.gz | mysql -u USER -pPASSWORD DATABASE
{% endhighlight %}

### Run crontab task with lockf or lockfile
{% highlight bash %}
*/5 * * * * userlogin /usr/bin/lockf -st 0 /tmp/5min.lock  sh cron1.sh
*/5 * * * * userlogin lockfile -s0 -r0 /tmp/5min.lock && (sh cron1.sh ; rm -f /tmp/5min.lock)
{% endhighlight %}

### Run crontab everyday except Saturday
{% highlight bash %}
0 * * * 0,1,2,3,4,6 userlogin sh cron1.sh
{% endhighlight %}

### Create rsync share
{% highlight bash %}
/etc/rsyncd.conf
[www]
path = /www
list = yes
read only = yes
hosts allow = 10.0.0.0/8
dont compress = *.*

rsync -avP server::www/ /www1/
{% endhighlight %}

### Count /tmp used disk space 
{% highlight bash %}
sudo du -hs /tmp/*
{% endhighlight %}

### Clean Yum pkg cache
{% highlight bash %}
Pkg cache live here - /var/cache/yum/updates 
yum clean all
{% endhighlight %}


### MySQL Master-Slave replication
{% highlight bash %}
At master
grant REPLICATION SLAVE on *.*  to 'replication'@'IP' identified by 'P@ssw0rd';
show master status;

At slave
slave stop;
change master to MASTER_HOST="master", MASTER_LOG_FILE="mysql-bin.000013", MASTER_LOG_POS=455758064;
slave start;
show slave status\G;
{% endhighlight %}

### Change MySQL root password
{% highlight bash %}
use mysql;update user set password=password('P@ssw0rd') where user='root';
flush privileges;
{% endhighlight %}

### Megarc raid cmd
{% highlight bash %}
megarc -dispCfg -a0
run rebuild
megarc -dorbld -a0 -rbldarray[0:1]
http://www.freebsdwiki.net/index.php/Megarc
{% endhighlight %}

### Megacli raid cmd
{% highlight bash %}
http://hwraid.le-vert.net/wiki/LSIMegaRAIDSAS
server:~# megacli -AdpGetProp RebuildRate -a0
Adapter 0: Rebuild Rate = 30%
server:~# megacli -AdpSetProp RebuildRate 60 -a0
Adapter 0: Set rebuild rate to 60% success.
LINUX
server:~# cat /proc/sys/dev/raid/speed_limit_min
1000
server:~# cat /proc/sys/dev/raid/speed_limit_max
200000

Speed up limit to 50 mb\s
server:~# echo 50000 > /proc/sys/dev/raid/speed_limit_min
{% endhighlight %}

### SSH tunnel
{% highlight bash %}
Local Port Forwarding
ssh -L 3306:localhost:3306 username@hostname
telnet localhost 3306

Remote Port Forwarding
ssh -R 9000:localhost:8001 username@hostname
ssh -R 2222:localhost:22 username@hostname - SSH
ssh -R 2223:localhost:5902 username@hostname - VNC
autossh -M 20000 -f -R 2222:localhost:80 username@hostname
telnet someserver 9000 -> go to localhost:8001
{% endhighlight %}

### Ram disk FreeBSD
{% highlight bash %}
/etc/rc.conf
mdconfig_md0="-t malloc -s 512m -u 0"
mdconfig_md0_newfs="-U"
mdconfig_md0_owner="www"
mdconfig_md0_perms="775"
mdconfig_md0_cmd="chown www:www /www/ramdisk"
mkdir -p /www/ramdisk
/etc/rc.d/mdconfig start
df -h
{% endhighlight %}

### Add firewall rules Linux or FreeBSD
{% highlight bash %}
Linux
iptables -A INPUT -s 127.0.0.1 -p tcp --dport 8080 -j ACCEPT
service iptables save
iptables -nL | grep 8080

FreBSD
ipfw add pass tcp from 127.0.0.1 to me 8080 setup 
sh /usr/share/examples/ipfw/change_rules.sh
ipfw list | grep 8080
{% endhighlight %}

### Add 6G swap to FreeBSD
{% highlight bash %}
dd if=/dev/zero of=/www/swap0 bs=1M count=6144
chmod 0600 /www/swap0
/etc/rc.conf
swapfile="/www/swap0"
mdconfig -a -t vnode -f /www/swap0 -u 0 && swapon /dev/md0
{% endhighlight %}

### Clone disk with dd
{% highlight bash %}
dd if=/dev/old_disk of=/dev/new_disk conv=noerror,sync
{% endhighlight %}
