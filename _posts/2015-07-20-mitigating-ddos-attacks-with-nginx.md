---
layout: post
title: "Mitigating DDoS Attacks with NGINX"
modified: 2015-07-20 12:44:24 +0300
category: [howto]
tags: [nginx,sysadm,linux]
image:
  feature: 
  credit: 
  creditlink: 
comments: True
share: 
---
Useful nginx configs for antiddos

### Limiting the Rate of Requests
{% highlight nginx %}
limit_req_zone $binary_remote_addr zone=one:10m rate=30r/m;
server {
    ...
    location /login.html {
        limit_req zone=one;
    ...
    }
}
{% endhighlight %}

### Limiting the Number of Connections
{% highlight nginx %}
limit_conn_zone $binary_remote_addr zone=addr:10m;

server {
    ...
    location /store/ {
        limit_conn addr 10;
        ...
    }
}
{% endhighlight %}

### Closing Slow Connections
{% highlight nginx %}
server {
    client_body_timeout 5s;
    client_header_timeout 5s;
    ...
}
{% endhighlight %}

### Blacklisting IP Addresses
{% highlight nginx %}
location / {
    deny 123.123.123.0/28;
    deny 123.123.123.3;
    deny 123.123.123.5;
    deny 123.123.123.7;
    ...
}
{% endhighlight %}

### Whitelisting IP Addresses
{% highlight nginx %}
location / {
    allow 192.168.1.0/24;
    deny all;
    ...
}
{% endhighlight %}

### Blocking Requests
{% highlight nginx %}
location /foo.php {
    deny all;
}

location / {
    if ($http_user_agent ~* foo|bar) {
        return 403;
    }
    ...
}
{% endhighlight %}

### Limiting Connections to Back-Ends
{% highlight nginx %}
upstream website {
    server 192.168.100.1:80 max_conns=200;
    server 192.168.100.2:80 max_conns=200;
    queue 10 timeout=30s;
}
{% endhighlight %}

