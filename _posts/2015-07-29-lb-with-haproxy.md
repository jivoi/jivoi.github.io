---
layout: post
title: "LB with Haproxy"
modified: 2015-07-29 14:56:16 +0300
category: [howto]
tags: [linux,haproxy,sysadm]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---
Simple HTTP\HTTPS Load Balancing with Haproxy

### Install Haproxy
{% highlight bash %}
$ add-apt-repository -y ppa:vbernat/haproxy-1.5
$ apt-get update
$ apt-get install -y haproxy
{% endhighlight %}

### Simple Haproxy.cfg
{% highlight bash %}
# /etc/haproxy/haproxy.cfg

global
    log /dev/log    local0
    log /dev/log    local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

    # Default SSL material locations
    ca-base /etc/ssl/certs
    crt-base /etc/ssl/private

    # Default ciphers to use on SSL-enabled listening sockets.
    ssl-default-bind-ciphers kEECDH+aRSA+AES:kRSA+AES:+AES256:RC4-SHA:!kEDH:!LOW:!EXP:!MD5:!aNULL:!eNULL

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000
    errorfile 400 /etc/haproxy/errors/400.http
    errorfile 403 /etc/haproxy/errors/403.http
    errorfile 408 /etc/haproxy/errors/408.http
    errorfile 500 /etc/haproxy/errors/500.http
    errorfile 502 /etc/haproxy/errors/502.http
    errorfile 503 /etc/haproxy/errors/503.http
    errorfile 504 /etc/haproxy/errors/504.http

frontend localhost
    bind *:80
    bind *:443
    option tcplog
    mode tcp
    default_backend webnodes

backend webnodes
    mode tcp
    balance roundrobin
    option ssl-hello-chk
    option forwardfor
    http-request set-header X-Forwarded-Port %[dst_port]
    http-request add-header X-Forwarded-Proto https if { ssl_fc }
    option httpchk HEAD / HTTP/1.1\r\nHost:localhost
    server web01 192.168.56.1:443 check
    server web02 192.168.56.2:443 check

listen stats *:1936
    stats enable
    stats uri /
    stats hide-version
    stats auth someuser:password
{% endhighlight %}

### Start Haproxy
{% highlight bash %}
$ service haproxy restart
{% endhighlight %}
