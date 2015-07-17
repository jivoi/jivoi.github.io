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
# at master /etc/my.cnf
server-id=1
binlog-format   = mixed
log-bin=mysql-bin
datadir=/var/lib/mysql
innodb_flush_log_at_trx_commit=1
sync_binlog=1

CREATE USER replicant@<<slave-server-ip>>;
GRANT REPLICATION SLAVE ON *.* TO replicant@<<slave-server-ip>> IDENTIFIED BY '<<choose-a-good-password>>';

$ mysqldump --skip-lock-tables --single-transaction --flush-logs --hex-blob --master-data=2 -A  > ~/dump.sql
$ head dump.sql -n80 | grep "MASTER_LOG_POS"
$ scp ~/dump.sql.gz mysql-user@<<slave-server-ip>>:~/

# at slave /etc/my.cnf
server-id               = 101
binlog-format       = mixed
log_bin                 = mysql-bin
relay-log               = mysql-relay-bin
log-slave-updates = 1
read-only               = 1

$ gunzip ~/dump.sql.gz
$ mysql -u root -p < ~/dump.sql

CHANGE MASTER TO MASTER_HOST='<<master-server-ip>>',MASTER_USER='replicant',MASTER_PASSWORD='<<slave-server-password>>', MASTER_LOG_FILE='<<value from above>>', MASTER_LOG_POS=<<value from above>>;
START SLAVE;
SHOW SLAVE STATUS \G;

# fix some replication errors
STOP SLAVE;SET GLOBAL SQL_SLAVE_SKIP_COUNTER = 1;START SLAVE;
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
http://tools.rapidsoft.de/perc/perc-cheat-sheet.html
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

### Access to svn server with ssh-key
{% highlight bash %}
useradd svnuser
ssh-keygen -t rsa
mv ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys
add to ~/.ssh/authorized_keys
no-pty,no-port-forwarding,no-X11-forwarding,no-agent-forwarding,command="/usr/bin/svnserve -t -r /www/svn"
{% endhighlight %}

### Create iso image with dd
{% highlight bash %}
sudo dd if=/dev/scd0 of=/tmp/isoimage.iso
sudo mount -t udf,iso9660  -o loop /tmp/isoimage.iso /mnt/cdrom/
{% endhighlight %}

### Create swap in Linux
{% highlight bash %}
fdisk /dev/sda
mkswap -L 'swap' /dev/sda6
swapon -a
{% endhighlight %}

### Split big file in small parts
{% highlight bash %}
split -b1m large.mp3 large.mp3.
collect back
cat large.mp3.* > large.mp3
{% endhighlight %}

### Show PostreSQL status
{% highlight bash %}
select * from pg_stat_activity;
{% endhighlight %}

### Soft Raid FreeBSD
{% highlight bash %}
echo 'geom_mirror_load="YES"' >> /boot/loader.conf
sysctl kern.geom.debugflags=16
gmirror label -v -b round-robin -s 131072 gm0 /dev/mfid0
change /etc/fstab /dev/mfid0s2a to /dev/mirror/gm0s1a
reboot
gmirror list
gmirror status
gmirror insert gm0 /dev/mfid1
gmirror configure -b round-robin -s 131072 gm*
gmirror remove gm0 /dev/mfid1
gmirror foreget -v gm0
gmirror rebuild -v gm1 /dev/fmid3
{% endhighlight %}

### Test channel speed
{% highlight bash %}
at server:
iperf -s
at client:
iperf -V -c SERVERIP -t 6000
{% endhighlight %}

### Patch apply
{% highlight bash %}
patch --dry-run -p1 < patchfile.patch
if all ok
patch -p1 < patchfile.patch
{% endhighlight %}

### Revoke all grant and remove MySQL user
{% highlight bash %}
REVOKE ALL PRIVILEGES on `DBNAME`.* from 'USERNAME'@'IP' ;
drop user 'USERNAME'@'IP';
select * from mysql.user\G;
select * from mysql.user where user='USERNAME'\G;
{% endhighlight %}

### Cron task start at reboot
{% highlight bash %}
/etc/crontab
@reboot         username /usr/bin/bash  /etc/startAtReboot.sh
{% endhighlight %}

### Simple rsyncd.conf
{% highlight bash %}
/etc/rsyncd.conf
pid file = /var/run/rsyncd.pid
use chroot = yes
uid = nobody
gid = nobody
hosts allow = 192.168.56.0/24
hosts deny  = *
pid file = /var/run/rsyncd.pid
[test]
path=/test
comment=test
read only = yes
hosts allow = 10.0.0.1
hosts deny  = *

To start
rsync --daemon
{% endhighlight %}

### Open files limit
{% highlight bash %}
http://ss64.com/bash/limits.conf.html
/etc/security/limits.conf
*               hard    nofile          65535
*               soft    nofile          65535
username        hard    nofile          65536
{% endhighlight %}

### Use curl to check web site answer time
{% highlight bash %}
curl -w '\nLookup time:\t%{time_namelookup}\nConnect time:\t%{time_connect}\nPreXfer time:\t%{time_pretransfer}\nStartXfer time:\t%{time_starttransfer}\n\nTotal time:\t%{time_total}\n' -o /dev/null -s http://linux.com/
{% endhighlight %}

### Run vncserver at port 5999
{% highlight bash %}
vncserver -geometry 1024x768 -depth 24 :99
{% endhighlight %}

### Create 200 host records in /etc/hosts
{% highlight bash %}
192.168.99.1-200 n001-n200
P=1; for i in $(seq -w 200); do echo "192.168.99.$P n$i"; P=$(expr $P + 1);done >>/etc/hosts
{% endhighlight %}

### Com terminal for cisco
{% highlight bash %}
apt-get install cutecom(minicom)
{% endhighlight %}

### Disable php for custom dir in Apache
{% highlight bash %}
<Directory /var/www/htdocs/images>
    RemoveHandler .php .phtml .php3
    AddType application/x-httpd-php-source .php .phtml .php3
    Allow from all
 </Directory>
{% endhighlight %}

### Print all ps pids with owner root
{% highlight bash %}
ps -aux | awk '{if ($1 == "root") print $2}'
{% endhighlight %}

### Set expired password for FreeBSD user
{% highlight bash %}
echo P@ssw0rd|sudo /usr/sbin/pw usermod username -h0 -p 1
{% endhighlight %}

### Enable coredumps in FreeBSD or Linux
{% highlight bash %}
FreeBSD
sysctl kern.coredump=1
sysctl kern.sugid_coredump=1
sysctl kern.corefile=/core/%N-%P.core
%N - name of process
%P - PID
%U - username login

Linux
mkdir /core
chmod 777/core
echo "/core" > /proc/sys/kernel/core_pattern
sysctl kernel.core_pattern=/core/%P.core
{% endhighlight %}

### Enable coredumps in NginX
{% highlight bash %}
Need to compile nginx with --with-debug
Add to nginx.conf
worker_rlimit_core 50m;
working_directory /core/;
echo 'www soft core unlimited' >> /etc/security/limits.conf
/etc/init.d/httpd restart
{% endhighlight %}

### Add alias to network interface in FreeBSD
{% highlight bash %}
ifconfig em0 alias 192.168.56.100/32
{% endhighlight %}

### Print all locked request in MySQL
{% highlight bash %}
mysql -e "show full processlist" | grep "Locked"
{% endhighlight %}

### Redirect port from 5190 to 5222 with iptables
{% highlight bash %}
iptables -A INPUT -p tcp --dport 5190 -j ACCEPT
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 5190 -j REDIRECT --to-ports 5222
{% endhighlight %}

### Limit POST request size to 20MB
{% highlight bash %}
add to php.ini
php_value max_execution_time 600
php_value upload_max_filesize 20M
php_value post_max_size 20M
{% endhighlight %}

### Apache error log limit 2G
{% highlight bash %}
[notice] child pid 15443 exit signal File size limit exceeded (25)
some where you have log file size more than 2G, find it
find /logs/* -size +2000000k
{% endhighlight %}

### Change nginx version number
{% highlight bash %}
src/core/nginx.h
nginx version: nginx/0.7.62
recompile from source
{% endhighlight %}
