---
layout: post
title: "Move from HDD to SSD with ArchLinux"
modified: 2016-04-04 15:44:01 +0300
category: [linux]
tags: [sysadm, linux, howto]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---

Migrate ArchLinux from HDD to SDD

### System prepare
{% highlight bash %}
# clean pacman cache
$ pacman -Scc
{% endhighlight %}

### Boot from the Arch liveCD
{% highlight bash %}
# partitioned via gdisk /dev/sdb1 for /boot 1G and /dev/sdb2 for / with all space

$ gdisk /dev/sdb
$ mkfs.ext4 /dev/sdb1
$ mkfs.ext4 /dev/sdb2
$ mount /dev/sdb2 /mnt
$ mkdir /mnt/boot
$ mount /dev/sdb1 /mnt/boot
$ mkdir /mnt_old
$ mount /dev/sda3 /mnt_old
$ rsync -aAXv --progress /mnt_old /mnt
$ genfstab -U -p /mnt > /mnt/etc/fstab
$ mount --bind /dev /mnt/dev
$ mount --bind /proc /mnt/proc
$ mount --bind /sys /mnt/sys
$ chroot /mnt /bin/bash
$ grub-install --debug --recheck /dev/sdb
$ grub-install --target=i386-pc --debug --recheck /dev/sdb
$ grub-mkconfig -o /boot/grub/grub.cfg
$ mkinitcpio -p linux
{% endhighlight %}

### Edit fstab
{% highlight bash %}
# add noatime,discard for SSD partions
echo "tmpfs   /tmp       tmpfs   defaults,noatime,mode=1777   0 0" >> /etc/fstab
{% endhighlight %}

### Enable deadline scheduler for SSD
{% highlight bash %}
$ vi /etc/udev/rules.d/60-schedulers.rules
ACTION=="add|change", KERNEL=="sdb", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="deadline"
{% endhighlight %}

### Enable FSTRIM service
{% highlight bash %}
$ systemctl enable fstrim.service
{% endhighlight %}

### Exit chroot add reboot
{% highlight bash %}
$ exit
$ reboot
{% endhighlight %}
