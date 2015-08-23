---
layout: post
title: "Playing with Docker"
modified: 2015-07-02 12:10:18 +0300
category: [howto]
tags: [linux,sysadm,docker]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---
Learn how to use Docker

### Sites
- [Docker Site](https://www.docker.com/)
- [Wikipedia](https://en.wikipedia.org/wiki/Docker_(software))
- [Awesome Docker/](https://veggiemonk.github.io/awesome-docker/)

### Video
- [Pluralsight - Docker Deep Dive](http://www.pluralsight.com/courses/docker-deep-dive)


### First steps with Docker
{% highlight bash %}
# install docker
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo sh -c "echo deb https://get.docker.com/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install lxc-docker

# launch simple container
sudo docker pull phusion/baseimage
sudo docker run -i -t phusion/baseimage:latest /sbin/my_init -- bash -l
sudo docker ps

# save container image
sudo docker commit <container id> baseimage-ssh
sudo docker stop <container id>

# launch container with demonisation
sudo docker run -d -i -t baseimage-ssh /sbin/my_init

# get container IP
sudo docker inspect -f "{{ .NetworkSettings.IPAddress }}" <container id>

# launch container with ssh port forwarding
sudo docker stop <container id>
sudo docker run --dns 192.168.0.1 -p 127.0.0.1:222:22 -d -i -t baseimage-ssh /sbin/my_init
ssh -p 222 root@localhost

# install nginx in container, save
apt-get update
apt-get install nginx
service nginx start
curl localhost

echo "service nginx start" > /etc/my_init.d/01_services.sh
chmod a+x /etc/my_init.d/01_services.sh

sudo docker ps
sudo docker commit <container id> baseimage-nginx
sudo docker stop <container id>

# launch nginx image
sudo docker run --name docker-nginx --dns 192.168.0.1 -p 127.0.0.1:222:22 -p 127.0.0.1:8080:80 -d -i -t baseimage-nginx /sbin/my_init
curl localhost:8080

# stop nginx container
sudo docker stop docker-nginx

# rollback to last image version
sudo docker run -i -t baseimage-nginx:latest /sbin/my_init --skip-startup-files -- bash -l

# export container image
sudo docker save -o baseimage-nginx.img baseimage-nginx

# import container image
sudo docker load -i baseimage-nginx.img
{% endhighlight %}
