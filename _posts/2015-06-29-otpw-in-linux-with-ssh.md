---
layout: post
title: "OTPW for SSH in Linux"
modified: 2015-06-29 11:46:36 +0300
category: [howto]
tags: [linux,ubuntu,security]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---
How to use One Time Password for SSH in Ubuntu Linux

### Install deb pkgs
{% highlight bash %}
apt-get install -y libpam-otpw otpw-bin
{% endhighlight %}

### Add OTPW pam modules in /etc/pam.d/sshd
{% highlight bash %}
#@include common-auth

#Enable OTPW Authentication
auth       required     pam_otpw.so
session    optional     pam_otpw.so
{% endhighlight %}

### Check /etc/ssh/sshd_config
{% highlight bash %}
UsePrivilegeSeparation yes
ChallengeResponseAuthentication yes
UsePAM yes
PubkeyAuthentication yes
PasswordAuthentication no

Now you can restart sshd:
service ssh restart

After you can login to server only with ssh-key or otpw =)
{% endhighlight %}

### Generate OTPW list for $USER
{% highlight bash %}
su - user
otpw-gen > otpw_list.txt 
enter prefix for password list
for ex 123
{% endhighlight %}

### Login with OTPW to server
{% highlight bash %}
ssh user@remote_host
Password 126:
Welcome to Ubuntu 14.04.1 LTS (GNU/Linux 3.13.0-32-generic x86_64)

Find password in otpw_list and add your prefix to it, you will get 123LQQF uFOW
126 LQQF uFOW
{% endhighlight %}
