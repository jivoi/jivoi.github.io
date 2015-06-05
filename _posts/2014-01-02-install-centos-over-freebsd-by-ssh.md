---
layout: post
title: "Установка CentOS из под FreeBSD по SSH"
modified: 2014-01-02 12:43:49 +0300
category: [howto]
tags: [centos, freebsd]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---
Руководство как установить CentOS из под FreeBSD по SSH.
Задавайте вопросы в комментах, если что-то не понятно.

### Дано:
1. Настроенный сервер с kickstart
2. Сервер с FreeBSD любой версии который будем переустанавливать
3. Прямые руки. =)

### 1.Устанавливаем нужные пакеты из портов(GRUB2 и e2fsprogs) на FreeBSD
{% highlight bash %}
cd /usr/ports/sysutils/grub2&&make install
cd /usr/ports/sysutils/e2fsprogs&&make install
{% endhighlight %}

### 2.Создаем на разделе /tmp ext2 файловую систему
{% highlight bash %}
/dev/amrd0s1f              1.9G    155M    1.6G     9%    /tmp
/dev/amrd0s1f on /tmp (ufs, local, soft-updates)

umount /tmp
mke2fs /dev/amrd0s1f
mount -t ext2fs /dev/amrd0s1f /mnt
{% endhighlight %}

Незабыть удалить из /etc/fstab, чтобы можно было загрузится в BSD если чтото пойдет не так!

### 3. Копируем на ext2 раздел initrd и vmlinuz нужной версии
{% highlight bash %}
fetch -o /mnt/initrd_remote.img http://mirror.yandex.ru/centos/6.0/os/x86_64/isolinux/initrd.img
fetch -o /mnt/vmlinuz_remote http://mirror.yandex.ru/centos/6.0/os/x86_64/isolinux/vmlinuz

wget -O /initrd_remote.img http://mirror.yandex.ru/centos/6.0/os/x86_64/isolinux/initrd.img
wget -O /vmlinuz_remote http://mirror.yandex.ru/centos/6.0/os/x86_64/isolinux/vmlinuz
{% endhighlight %}

### 4.Устанавливаем grub2 в MBR и создаем кофиг загрузки
{% highlight bash %}
grub2-install /dev/amrd0
grub-mkconfig
/usr/local/etc/grub.d/00_header
/usr/local/etc/grub.d/40_custom
grub-mkconfig -o /boot/grub/grub.cfg
{% endhighlight %}

Нужно поправить /usr/local/etc/grub.d/00_header выставив default=1
В /usr/local/etc/grub.d/40_custom прописать наш новый тип загрузки, для CentOS 6 x64 он будет следующим.

**ИЗМЕНИТЬ ВСЕ НУЖНЫЕ ЗНАЧЕНИЯ НА ПРАВИЛЬНЫЕ!**

1.  root='(hd0,1,f)' - буква должна соответствовать букве /tmp слайса!! в нашем случае это /dev/amrd0s1f тоесть f
2. ks файл
3. IP\GATE\NETMASK!
4. НЕ ЗАБЫТЬ ВЫПОЛНИТЬ grub-mkconfig -o /boot/grub/grub.cfg чтобы обновился конфиг grub!!

{% highlight bash %}
menuentry "CentOS"  {
        insmod ext2
        set root='(hd0,1,f)'
        linux /vmlinuz_remote lang=en_US keymap=us method=http://ks.example.com/ ks=http://ks.example.com/ks.cfg vnc vncpassword=qwe123 ksdevice=eth0 ip=192.168.0.10 netmask=255.255.255.0 gateway=192.168.0.1 dns=8.8.8.8 noselinux headless
{% endhighlight %}
