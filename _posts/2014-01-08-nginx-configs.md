---
layout: post
title: "Useful nginx configs"
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
Different configs for nginx.

<section id="table-of-contents" class="toc">
<header>
<h3>Contents</h3>
</header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section><!-- /#table-of-contents -->

### Default vhost config
{% highlight nginx %}
server {
listen 80;
    server_name _;
    access_log /var/log/nginx/access_log;
    error_log /var/log/nginx/nginx_error_log;

    allow MYIP/32; #dev pc
    satisfy any;
    auth_basic  "restricted area";
    auth_basic_user_file  /var/www/.htpasswd;

    location ~* ^.+\.(jpe?g|gif|css|js|ico|png|bmp|xml|swf|ico|flv|exe|zip|rar|htm|html)$ {
        root /var/www/;
    }

    location / {
	proxy_pass http://127.0.0.1:80;
    }
    location ~ /.svn/ {
	deny all;
    }
}
{% endhighlight %}

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

### Rewrite location for special User-Agent
{% highlight nginx %}
location / {
    if ($http_user_agent = "Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en)") {
		rewrite ^ /index.php break;
}

to check
wget --no-cache --user-agent="Mozilla/5.0 (iPhone; U; CPU like Mac OS X; en)" http://domain.net -O /dev/null
{% endhighlight %}

### Simple block of SQL Injection
{% highlight nginx %}
location / {
	if ($request_uri ~* "union|concat") {
		return 403;
    }
    proxy_pass      http://127.0.0.1/;
}
{% endhighlight %}

### Rewrite location name to get args
{% highlight nginx %}
e.x /en/bla.php rewrite to /bla.php?lang=en, or /en/bla.php?a=1 to /bla.php?a=1&lang=en

location ~* ^/en {
    set $args $args&lang=en;
    rewrite ^/en/(.*)$ /$1 ;
}
{% endhighlight %}

### Change robots.txt for different domain
{% highlight nginx %}
location = /robots.txt {
    root /var/www;
    if ( $host = domain.net ) {
        rewrite ^/robots.txt$ /robots_domain.txt;
        }
    }
location = /robots_domain.txt {
    root /var/www2;
}
{% endhighlight %}

### Creates variables suitable for A/B testing, also known as split testing
{% highlight nginx %}
split_clients "$cookie_ruid"  $sharding {
				50%                1;
				50%                2;
}
if ($sharding = '1') {
	proxy_pass http://one.domain.ru;
}
if ($sharding = '2') {
	proxy_pass http://two.domain.ru;
}
{% endhighlight %}

### No cache for 502 error
{% highlight nginx %}
error_page 502 = @502;
location @502 {
	add_header Pragma "no-cache";
	expires off;
	add_header Cache-Control "no-store, no-cache, must-revalidate, post-check=0, pre-check=0";
	charset utf-8;
	root /var/www/err;
	rewrite .* /index.html break;
}
{% endhighlight %}

### Create nearly equal redirect from domain.net to 3 others: one.domain.net, two.domain.net, three.domain.net
{% highlight nginx %}
server {
    listen :80;
    server_name domain.net;
    location / {
        root /var/www;
        random_index  on;
    }
}

Create 3 files in /var/www index1.html index2.html index3.html

cat /var/www/index1.html

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<meta http-equiv="REFRESH" content="0;url=http://one.domain.net"</HEAD>
</HTML>
{% endhighlight %}

### Custom 403 error page
{% highlight nginx %}
error_page 403 /403.html;
location = /403.html {
    allow all;
    root /var/www/err/;
}
{% endhighlight %}

### Rewrite requests for special remote address
{% highlight nginx %}
location  / {
    if ($remote_addr ~ "8.8.8.8") {
        rewrite  ^(.*)$  /index2.html break;
    }
    proxy_pass http://backend;
}
{% endhighlight %}

### Rewrite sub domains to new domain
{% highlight nginx %}
server {
    listen 80;
    server_name domain.ru *.domain.ru;
    #rewrite all subdomains on $1.b.dot.ru
    if ($host ~* "^([a-z0-9-\.]+)\.domain.ru$"){
        set $subd $1;
        rewrite ^(.*)$ http://$subd.b.dot.ru$1 permanent;
        break;
    }
    #rewrite domain.ru in b.dot.ru
    if ($host ~* "^domain.ru$"){
        rewrite ^(.*)$ http://b.dot.ru$1 permanent;
        break;
    }
}
{% endhighlight %}

### New format for 301 redirect
{% highlight nginx %}
Old format:
rewrite ^(.*) https://www.blabla.ru$1 permanent;

New format:
return 301 https://www.blabla.ru$request_uri;
{% endhighlight %}

### Location for static files
{% highlight nginx %}
location ~* ^.+\.(jpe?g|gif|css|js|ico|png|bmp|xml|swf|ico|flv|exe|zip|rar|htm|html)$ {
    root /var/www/;
}
{% endhighlight %}

### Time Based Rewriting Rules
{% highlight nginx %}
# rule will work from 2:00 AM to 4:00 AM
location / {
  rewrite_by_lua '
    local current_time = os.time()
    local start_time = os.time({year=2015,month=7,day=22,hour=02,min=0,sec=0})
    local end_time = os.time({year=2015,month=7,day=22,hour=04,min=00,sec=0})

    if current_time >= start_time and current_time <= end_time then
      return ngx.redirect("https://yoursite.com/maintenance.html")
    end
  ';
}
{% endhighlight %}

### Hardening HTTP response headers
{% highlight nginx %}
add_header Content-Security-Policy "default-src https: data: 'unsafe-inline' 'unsafe-eval'" always;
add_header Strict-Transport-Security "max-age=31536000; includeSubdomains" always;
add_header Public-Key-Pins "pin-sha256='X3pGTSOuJeEVw989IJ/cEtXUEmy52zs1TZQrU06KUKg=';
pin-sha256='MHJYVThihUrJcxW6wcqyOISTXIsInsdj3xK8QrZbHec=';
pin-sha256='isi41AizREkLvvft0IRW4u3XMFR2Yg7bvrF7padyCJg=';
includeSubdomains; max-age=2592000" always;
add_header X-Frame-Options "SAMEORIGIN" always;
add_header X-Xss-Protection "1; mode=block" always;
add_header X-Content-Type-Options "nosniff" always;

# change nginx server header
./src/http/ngx_http_header_filter_module.c

# check header
https://securityheaders.io/
{% endhighlig