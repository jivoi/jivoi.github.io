---
layout: post
title: "Ubuntu Security Hardening"
modified: 2015-07-22 18:11:54 +0300
category: [howto]
tags: [linux,security,sysadm]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---
Based on CIS and my experience

<section id="table-of-contents" class="toc">
<header>
<h3>Contents</h3>
</header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section><!-- /#table-of-contents -->

### SSHD Settings
{% highlight bash %}
# /etc/ssh/sshd_config
PermitRootLogin no
Port 1022

$ service ssh reload
{% endhighlight %}

### Limit Access to SU cmd
{% highlight bash %}
$ dpkg-statoverride --update --add root sudo 4750 /bin/su
{% endhighlight %}

### Network Security Systcl
{% highlight bash %}
# /etc/sysctl.d/10-network-security.conf
# Ignore ICMP broadcast requests
net.ipv4.icmp_echo_ignore_broadcasts = 1

# Disable source packet routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Ignore send redirects
net.ipv4.conf.all.send_redirects = 0
net.ipv4.conf.default.send_redirects = 0

# Block SYN attacks
net.ipv4.tcp_max_syn_backlog = 2048
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 5

# Log Martians
net.ipv4.conf.all.log_martians = 1
net.ipv4.icmp_ignore_bogus_error_responses = 1

# Ignore ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

# Ignore Directed pings
net.ipv4.icmp_echo_ignore_all = 1

$ service procps start
{% endhighlight %}

### Firewall with UFW
{% highlight bash %}
# install packegs
$ apt-get install ufw
$ ufw status verbose
$ ufw default allow incoming
$ ufw default allow outgoing
$ ufw enable
# add rules
$ ufw allow ssh
$ ufw allow 1022/tcp
$ ufw allow from 192.168.1.1
$ ufw allow 80/tcp
$ ufw default deny incoming
# resetting all rules to defauls
$ ufw reset
{% endhighlight %}

### PHP Settings
{% highlight bash %}
# /etc/php5/apache2/php.ini
disable_functions = show_source,system,shell_exec,passthru,exec,phpinfo,popen,proc_open,allow_url_fopen
expose_php = off
display_errors = off
track_errors = off
html_errors = off
{% endhighlight %}

### Apache Settings
{% highlight bash %}
# /etc/apache2/conf-enabled/security.conf
ServerTokens Prod
ServerSignature Off
TraceEnable Off
Header unset ETag
FileETag None

$ a2enmod headers
$ service apache2 restart
{% endhighlight %}

### Install Apache ModSecurity
{% highlight bash %}
$ apt-get install libapache2-mod-security2
$ mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf

# /etc/modsecurity/modsecurity.conf
SecRuleEngine On
SecRequestBodyLimit 16384000
SecRequestBodyInMemoryLimit 16384000

# Install OWASP ModSecurity Core Rule Set
$ git clone https://github.com/SpiderLabs/owasp-modsecurity-crs.git /etc/owasp-modsecurity/
$ mv /etc/owasp-modsecurity/modsecurity_crs_10_setup.conf.example /etc/owasp-modsecurity/modsecurity_crs_10_setup.conf
ls /etc/owasp-modsecurity/base_rules | xargs -I {} ln -s /etc/owasp-modsecurity/base_rules/{} /etc/modsecurity/activated_rules/{}
ls /etc/owasp-modsecurity/optional_rules | xargs -I {} ln -s /etc/owasp-modsecurity/optional_rules/{} /etc/modsecurity/activated_rules/{}

# /etc/apache2/mods-available/owasp-modsecurity.conf
Include "/etc/owasp-modsecurity/activated_rules/*.conf"

$ service apache2 restart
{% endhighlight %}

### Install Apache ModEvasive
{% highlight bash %}
$ apt-get install libapache2-mod-evasive
$ mkdir /var/log/mod_evasive
$ chown www-data:www-data /var/log/mod_evasive

# /etc/apache2/mods-available/evasive.conf
DOSSystemCommand
DOSEmailNotify admin@domain.com

$ a2enmod mod-evasive
{% endhighlight %}

### Install Rootkit Checkers
{% highlight bash %}
$ apt-get install rkhunter chkrootkit

# /etc/chkrootkit.conf
RUN_DAILY="true"

# /etc/default/rkhunter
CRON_DAILY_RUN="true"
CRON_DB_UPDATE="true"

$ mv /etc/cron.weekly/rkhunter /etc/cron.weekly/rkhunter_update
$ mv /etc/cron.daily/rkhunter /etc/cron.weekly/rkhunter_run
$ mv /etc/cron.daily/chkrootkit /etc/cron.weekly/
{% endhighlight %}

### Install Logwatch
{% highlight bash %}
$ apt-get install logwatch
$ mv /etc/cron.daily/00logwatch /etc/cron.weekly/

# /etc/cron.weekly/00logwatch
/usr/sbin/logwatch --output mail --range 'between -7 days and -1 days'
{% endhighlight %}

### Automatic Security Updates
{% highlight bash %}
# ONLY if you really know what you are doing
$ dpkg-reconfigure -plow unattended-upgrades
{% endhighlight %}

### Process Accounting
{% highlight bash %}
$ apt-get install acct
$ touch /var/log/wtmp

# /etc/cron.weekly/acct-report
#!/bin/bash

echo "USERS' CONNECT TIMES"
echo ""

ac -d -p

echo ""
echo "COMMANDS BY USER"
echo ""

users=$(cat /etc/passwd | awk -F ':' '{print $1}' | sort)

for user in $users ; do
  comm=$(lastcomm --user $user | awk '{print $1}' | sort | uniq -c | sort -nr)
  if [ "$comm" ] ; then
    echo "$user:"
    echo "$comm"
  fi
done

echo ""
echo "COMMANDS BY FREQUENCY OF EXECUTION"
echo ""

sa | awk '{print $1, $6}' | sort -n | head -n -1 | sort -nr
{% endhighlight %}

