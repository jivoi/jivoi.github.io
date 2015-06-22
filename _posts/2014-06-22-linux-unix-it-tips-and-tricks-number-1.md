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

### pHpinfo
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
