---
layout: post
title: "Useful nginx rewrite rules"
modified: 2014-01-08 12:43:49 +0300
category: [howto]
tags: [linux, nginx]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---
Different rewrite rules for nginx.

### Custom 502 error page
{% highlight nginx %}
error_page   502 =200 /empty.html;
proxy_intercept_errors  on;
location /empty.html {
	root    /var/www/;
}
{% endhighlight %}

### Rewrite somefile.php to somefile.txt
{% highlight nginx %}
location = /somefile.php {
	rewrite .* /somefile.txt;
}
{% endhighlight %}

### Rewrite all requests from abc.mysite.com/xyz.php to mysite.com/abc/index.php?p=xyz
{% highlight nginx %}
server{
server_name ~ ^(.*)\.mysite\.com$;
set $subdom $1;
location ~ \/(.*)\.php {
    set $script $1;
    rewrite ^ http://mysite.com/$subdom/index.php?p=$script;
    }
}
{% endhighlight %}

### Permanent redirect from domain to www.domain
{% highlight apache %}
<VirtualHost *:80>
  ServerName              example.com:80
  RedirectMatch permanent (.*) http://www.example.com$1
</VirtualHost>
{% endhighlight %}

{% highlight nginx %}
server {
	server_name example.com;
	rewrite ^(.*)$ http://www.example.com$1 permanent;
}

or

server {
	server_name ~^(?! www\.);
	rewrite ^ http://www.$host$request_uri permanent;
}

or

if ($host ~* www\.(.*)) {
    set $host_without_www $1;
    rewrite ^(.*)$ http://$host_without_www$1 permanent; 
}

{% endhighlight %}

### Rewrite request from img/site to images
{% highlight nginx %}
location /img/site {
	if (!-f $request_filename) { 
		rewrite ^/img/site/(.*) /images/$1 break;
	}
}
{% endhighlight %}

### Proxy pass all request for one location
{% highlight nginx %}
location ~ /one/two/(.*)/(.*)$ {
    rewrite /one/two/(.*)/(.*)$ /two/$1/$2 break;
    proxy_set_header Host two.domain.net;
    proxy_pass http://two.domain.net;
}
{% endhighlight %}

### Proxy pass all request for one location
{% highlight nginx %}
location /html/ {
    proxy_set_header Host html.example.ru;
    rewrite ^/html/js/id/([0-9]+) /js/id/$1.html break;
    proxy_pass  http://html.example.ru;
}
{% endhighlight %}

### Rewrite *.domain.ru domain.ru to *.domain.newdomain.ru domain.newdomain.ru
{% highlight nginx %}
location / {
    set $newdomain_host domain.newdomain.ru;
    if ($host ~ (.*).domain.ru) {
    	set $newdomain_host "$1.domain.newdomain.ru";
    }
    rewrite /(.*)$  http://$newdomain_host/$1 permanent;
}
{% endhighlight %}

### Redirect from http://domainone.ru/ to http://domaintwo.ru
{% highlight nginx %}
server {
    listen _;
    server_name domainone.ru;
    access_log off;
    rewrite ^(.*)$ http://domaintwo.ru/ permanent;
}
{% endhighlight %}

### Rewrite whole domain to other domain
{% highlight nginx %}
server {
    listen :80;
    server_name _;
    access_log off;
    rewrite ^(.*)$ http://newdomain.net/ permanent;
}
{% endhighlight %}

### For 404 error redirect to / of vhost
{% highlight nginx %}
proxy_intercept_errors on;
error_page 404  http://newdomain.net/;
{% endhighlight %}

### Turn on gzip compress
{% highlight nginx %}
gzip on;
gzip_min_length 1100;
gzip_buffers 8 16k;
gzip_types text/plain application/x-javascript text/css;
{% endhighlight %}

### Rewrite all request to not exists files to index.php
{% highlight nginx %}
if (!-e $request_filename) {
	rewrite ^.*$ /index.php last;
}
{% endhighlight %}

### Security /admin location
{% highlight nginx %}
location ^~ /admin {
    if (!-e $request_filename) {
    	rewrite ^(.*)$ /index.php$1 break;
    }
    proxy_pass http://127.0.0.1;
    allow 192.168.56.1/24;
    deny all;
    root /var/www;
}
{% endhighlight %}
