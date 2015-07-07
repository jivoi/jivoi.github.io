---
layout: post
title: "Playing with DevStack"
modified: 2015-07-07 14:09:37 +0300
category: [howto]
tags: [openstack,linux,sysadm]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---
Learn how to install DevStack

- [DevStack Site](http://docs.openstack.org/developer/devstack/)

### Add stack user
{% highlight bash %}
useradd -G sudo -m -U -s /bin/bash stack
passwd stack
{% endhighlight %}

### Add user sudo permissions
{% highlight bash %}
/etc/sudoers
stack ALL=(ALL:ALL) NOPASSWD: ALL
{% endhighlight %}

### System configuration for KVM
{% highlight bash %}
#we will use KVM
sudo rmmod kvm-intel
sudo sh -c "echo 'options kvm-intel nested=y' >> /etc/modprobe.d/dist.conf"
sudo modprobe kvm-intel
cat /sys/module/kvm_intel/parameters/nested
modinfo kvm_intel | grep nested
{% endhighlight %}

### Download DevStack
{% highlight bash %}
sudo apt-get install -y git
git clone https://github.com/openstack-dev/devstack.git -b stable/kilo && cd devstack
sudo mkdir /var/log/openstack
sudo chown stack:stack /var/log/openstack
{% endhighlight %}

### Create DevStack config
{% highlight bash %}
local.conf
[[local|localrc]]
HOST_IP=192.168.0.250                        # Controller IP
FLAT_INTERFACE=p2p1                          # Outside interface
FIXED_RANGE=10.10.128.0/24                   # Virtual network
FIXED_NETWORK_SIZE=254                       # Virtual network size
FLOATING_RANGE=192.168.0.0/24                # Outside network
LOGFILE=/var/log/openstack/stack.sh.log      # Log directory
LOGDAYS=3
ADMIN_PASSWORD=admin
MYSQL_PASSWORD=P@ssw0rd
RABBIT_PASSWORD=P@ssw0rd
SERVICE_PASSWORD=P@ssw0rd
SERVICE_TOKEN=AAAAB3NzaC1yc2EAAAADAQABAAABAQCyYjfgyPazTvGpd8OaAvtU2utL8W6gWC4JdRS1J95G
REGION_NAME=DevStack                         # Region Name
LIBVIRT_TYPE=kvm                             # Use KVM
VOLUME_BACKING_FILE_SIZE=200G
{% endhighlight %}

### Setup DevStack
{% highlight bash %}
./stack.sh

# after you will see
Horizon is now available at http://192.168.0.250/
Keystone is serving at http://192.168.0.250:5000/v2.0/
Examples on using novaclient command line is in exercise.sh
The default users are: admin and demo
The password: admin
This is your host ip: 192.168.0.250
{% endhighlight %}

### Add LVM volume
{% highlight bash %}
sudo losetup -a
# add to /etc/rc.local
losetup /dev/loop0 /opt/stack/data/stack-volumes-lvmdriver-1-backing-file
{% endhighlight %}

### Reboot and Check
{% highlight bash %}
# after reboot
cd /home/stack/devstack && ./rejoin-stack.sh
{% endhighlight %}

### OpenStack images
- [Ubuntu-14.04-amd64](http://cloud-images.ubuntu.com/releases/14.04.2/release/ubuntu-14.04-server-cloudimg-amd64-disk1.img)
- [CentOS-7-x86_64](http://cloud.centos.org/centos/7/images/CentOS-7-x86_64-GenericCloud-1503.qcow20)
- [Windows](http://www.cloudbase.it/windows-cloud-images/)
