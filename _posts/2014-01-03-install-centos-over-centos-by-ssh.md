---
layout: post
title: "Как установить CentOS на %Linux% по SSH"
modified: 2014-01-03 12:43:49 +0300
category: [howto]
tags: [centos, ssh]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---
Как установить CentOS на другой %Linux% по SSH.
Это нам нужно если мы хотим поменять архитектуру i386 на x64 или поставить более новую версии поверх старой, в случае замены CentOS на CentOS или же если мы хотим заменить ArchLinux на CentOS.

### Дано:
1. Настроенный сервер с kickstart
2. Сервер с CentOS любой версии который мы будем переустанавливать
3. Прямые руки.

### 1. Скачиваем initrd и vmlinuz нужной версии
{% highlight bash %}
wget -O /boot/initrd_remote.img http://mirror.yandex.ru/centos/6.0/os/x86_64/isolinux/initrd.img
wget -O /boot/vmlinuz_remote http://mirror.yandex.ru/centos/6.0/os/x86_64/isolinux/vmlinuz
{% endhighlight %}

### 2. Правим /boot/grub/grub.conf
**ИЗМЕНИТЬ ВСЕ НУЖНЫЕ ЗНАЧЕНИЯ НА ПРАВИЛЬНЫЕ!**

1. ks файл
2. IP\GATE\NETMASK!**

{% highlight bash %}
title CentOS Remote Install
root (hd0,0)
kernel /boot/vmlinuz_remote lang=en_US keymap=us method=http://ks.example.com/ ks=http://ks.example.com/ks.cfg ip=192.168.0.10 netmask=255.255.255.0 gateway=192.168.0.1 dns=8.8.8.8 noselinux headless
initrd /boot/initrd_remote.img
{% endhighlight %}

### 3.Правим порядок загрузки из консоли
Предполагается, что наша конфигурация идет вторым пунктом меню.
Мы указали grub попробовать загрузить ее один раз.
Если что-то пойдет не так, вернемся к ранее установленному дистрибутиву после перезагрузки, через 120 секунд.

{% highlight bash %}
[root@localhost ~]# echo 'savedefault --default=1 --once' | grub --batch
{% endhighlight %}
