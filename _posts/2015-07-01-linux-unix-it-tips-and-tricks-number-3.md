---
layout: post
title: " Linux-Unix-IT Tips and Tricks #3"
modified: 2015-07-01 17:23:41 +0300
category: [howto]
tags: [linux,unix,sysadm]
image:
  feature: 
  credit: 
  creditlink: 
comments: True
share: 
---
Different Linux / Unix / IT tips, notes, howto part 3

<section id="table-of-contents" class="toc">
<header>
<h3>Contents</h3>
</header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section><!-- /#table-of-contents -->

### Other parts
[Part 1](https://jivoi.github.io/2014/06/22/linux-unix-it-tips-and-tricks-number-1/)
[Part 2](https://jivoi.github.io/2015/06/29/linux-unix-it-tips-and-tricks-number-2/)

### Speed up MySQL Import
{% highlight bash %}
mysql -u someuser -p SET AUTOCOMMIT=0; SET UNIQUE_CHECKS=0; SET FOREIGN_KEY_CHECKS=0; \
source dump.sql;SET FOREIGN_KEY_CHECKS=1; UNIQUE_CHECKS=1; COMMIT;
{% endhighlight %}

### Coreutils List
{% highlight bash %}
curl 'http://www.gnu.org/software/coreutils/manual/coreutils.html' 2>/dev/null |grep 'h3 class' | grep 'class="command"' | sed 's/.*class="command">//' | sed 's|</span></samp>||' | sed 's|</h3>||' | grep ':' | sort
{% endhighlight %}

### List all process swap space usage
{% highlight bash %}
for file in /proc/*/status ; do awk '/VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done
{% endhighlight %}

### Delete millions files from dir
{% highlight bash %}
# rm is fucked, this is ok =)
perl -e 'chdir "/tmp/1" or die; opendir D, "."; while ($n = readdir D) { unlink $n }'
{% endhighlight %}

### Nice Diff
{% highlight bash %}
diff --side-by-side fileA.txt fileB.txt | pager
{% endhighlight %}

### Run jobs with parallel
{% highlight bash %}
# apt-get install parallel
ls *.png | parallel -j4 convert {} {.}.jpg
{% endhighlight %}

### Awk PS SUM
{% highlight bash %}
ps alx | tail -n +2 | awk 'BEGIN{rss=0; vsz=0} {rss += $7; vsz+=$8} END{print rss, vsz;}'
{% endhighlight %}

### Show ext4 fragmentation %
{% highlight bash %}
# be carefull!!
for D in $( mount | awk '$5~/ext4/ { print $1 }' ); do sudo fsck.ext4 -nvf ${D}; done
non-contiguous is a % of fragmentation

e4defrag /
e4defrag -c /

# fragmentation for file
filefrag -v /PATH/TO/FILE
{% endhighlight %}

### Statistic of system resource
{% highlight bash %}
# apt-get install dstat
dstat -c --top-cpu -d --top-bio --top-latency
{% endhighlight %}

### Tcpdump with SSH stream
{% highlight bash %}
# stream through SSH the tcpdump output and analyze it locally with Wireshark
mkfifo /tmp/wshark
ssh root@ip "tcpdump -s 0 -U -n -w - -i eth0 not port 22" > /tmp/wshark
wireshark -k -i /tmp/wshark
{% endhighlight %}

### Linux Namespaces
{% highlight bash %}
Starting from kernel 2.6.24, Linux supports 6 different types of namespaces. Namespaces are useful in creating processes that are more isolated from the rest of the system, without needing to use full low level virtualization technology.

CLONE_NEWIPC: IPC Namespaces: SystemV IPC and POSIX Message Queues can be isolated.
CLONE_NEWPID: PID Namespaces: PIDs are isolated, meaning that a virtual PID inside of the namespace can conflict with a PID outside of the namespace. PIDs inside the namespace will be mapped to other PIDs outside of the namespace. The first PID inside the namespace will be ‘1’ which outside of the namespace is assigned to init
CLONE_NEWNET: Network Namespaces: Networking (/proc/net, IPs, interfaces and routes) are isolated. Services can be run on the same ports within namespaces, and “duplicate” virtual interfaces can be created.
CLONE_NEWNS: Mount Namespaces. We have the ability to isolate mount points as they appear to processes. Using mount namespaces, we can achieve similar functionality to chroot() however with improved security.
CLONE_NEWUTS: UTS Namespaces. This namespaces primary purpose is to isolate the hostname and NIS name.
CLONE_NEWUSER: User Namespaces. Here, user and group IDs are different inside and outside of namespaces and can be duplicated.
{% endhighlight %}

### Show daemon list need to restart after update
{% highlight bash %}
sudo lsof / | grep DEL | cut -f1 -d' ' | sort -u
{% endhighlight %}

### Increases TCPdump buffer
{% highlight bash %}
tcpdump -l -B 10000 host example.com
{% endhighlight %}

### Get Firefox bookmarks
{% highlight bash %}
sqlite3 ~/.mozilla/firefox/*.[dD]efault/places.sqlite "SELECT strftime('%d.%m.%Y %H:%M:%S', dateAdded/1000000, 'unixepoch', 'localtime'),url FROM moz_places, moz_bookmarks WHERE moz_places.id = moz_bookmarks.fk ORDER BY dateAdded;"
{% endhighlight %}

## SSL certs info
{% highlight bash %}
# show expire date of cert
openssl x509 -enddate -noout -in certnew.cer
# show all info of cert
openssl x509 -text -noout -in certnew.cer
# check that secret key (privkey.pem) is valid
openssl rsa -noout -text -in privkey.pem
{% endhighlight %}

## Reset root password on RHEL7\CentOS7
{% highlight bash %}
grub linux16 to the end of the line add "rd.break  console=tty1"
ctrl+x
switch_root:/# mount -o remount,rw /sysroot
switch_root:/# chroot /sysroot
sh-4.2# passwd root
sh-4.2# touch /.autorelabel
exit
{% endhighlight %}

### Blacklisting firewire in Linux
{% highlight bash %}
find /lib/modules/`uname -r` -name *firewire*
modinfo snd-firewire-lib
modinfo firewire-core
echo "blacklist firewire-core" > /etc/modprobe.d/blacklist-firewire.conf
modprobe --showconfig | grep blacklist #show blacklist modules
modprobe --showconfig | grep "^install" | grep "/bin"
{% endhighlight %}

### Install Ubuntu OpenStack
{% highlight bash %}
sudo apt-add-repository -y ppa:cloud-installer/stable
sudo apt-get update
sudo apt-get install -y openstack
sudo openstack-install
{% endhighlight %}

### Vagrant WinXP
{% highlight bash %}
# https://www.bram.us/2014/09/24/modern-ie-vagrant-boxes/
# http://aka.ms/vagrant-xp-ie6
vagrant box add winxpie6 http://aka.ms/vagrant-xp-ie6
vagrant init winxpie6
vagrant up
{% endhighlight %}

### Simple Cut Video in linux
{% highlight bash %}
# cut video from 00:02:52 to 00:03:45
ffmpeg -i original.mp4 -ss 00:02:52 -t 00:03:45 -async 1 -strict -2 cut.mp4
{% endhighlight %}

### How to clean TMP dir on boot
{% highlight bash %}
/etc/default/rcS
#TMPTIME=0
{% endhighlight %}

### The port scan attack detector - PSAD
{% highlight bash %}
# http://cipherdyne.org/psad/
apt-get install psad

/etc/syslog.conf
kern.info       |/var/lib/psad/psadfifo

/etc/init.d/sysklogd restart
/etc/init.d/klogd

/etc/psad/psad.conf
/etc/init.d/psad restart

iptables -A INPUT -j LOG
iptables -A FORWARD -j LOG

view port scan report
psad -S
{% endhighlight %}

### SNMPTrap using
{% highlight bash %}
/etc/default/snmpd
TRAPDRUN=yes

/etc/snmp/snmptrapd.conf
authCommunity log public

snmptrap -v 1 -c public 127.0.0.1 .1.3.6.1 localhost 6 17 '' .1.3.6.1 s "Just a test"

/var/log/syslog
Jun 23 12:14:47 linux snmptrapd[14221]: 2015-06-23 12:14:47 linux [127.0.0.1] (via UDP: [127.0.0.1]:58914->[127.0.0.1]) TRAP, SNMP v1, community public#012#011iso.3.6.1 Enterprise Specific Trap (17) Uptime: 1 day, 1:45:51.14#012#011iso.3.6.1 = STRING: "Just a test"

# tcpdump snmptraps
tcpdump -i eth1 -w test.log "udp and (src port 161 or 162)"
tcpdump -w troubleshoot.pcap -vv -A -T snmp "(dst port 162) or (src port 161) or (dst port 161)
{% endhighlight %}

### Remove Postfix Resiver Header
{% highlight bash %}
# add to /etc/postfix/header_checks
/^Received:.*with ESMTP/              IGNORE

# add to /etc/postfix/main.cf
mime_header_checks = regexp:/etc/postfix/header_checks header_checks = regexp:/etc/postfix/header_checks
postmap /etc/postfix/header_checks
postfix reload
{% endhighlight %}

### SSH key login only for one user
{% highlight bash %}
# add to /etc/ssh/sshd_config
Match user stew
PasswordAuthentication no

or

Match group dumbusers
PasswordAuthentication no
{% endhighlight %}

### Revert Firefox to init state
{% highlight bash %}
open about:support and press <Refresh Firefox>
{% endhighlight %}

### Limit MySQL and MongoDB mem usage with Cgroups
{% highlight bash %}
cgcreate -g memory:DBLimitedGroup
echo 16G > /sys/fs/cgroup/memory/DBLimitedGroup/memory.limit_in_bytes
sync; echo 3 > /proc/sys/vm/drop_caches
cgclassify -g memory:DBLimitedGroup `pidof mongod`
cgclassify -g memory:DBLimitedGroup `pidof mysqld_safe`
{% endhighlight %}

### Strace using
{% highlight bash %}
# file activity common syscalls:
access ()
close (close file handle)
fchmod (change file permissions)
fchown (change file ownership)
fstat (retrieve details)
lseek (move through file)
open (open file for reading/writing)
read (read a piece of data)
statfs (retrieve file system related details)

$ strace php 2>&1 | grep php.ini
$ strace -e open php 2>&1 | grep php.ini
$ strace -e open,access 2>&1 | grep your-filename
$ strace -p PID
# strace -c -p PID

# the network common syscalls:
bind – link the process to a network port
listen – allow to receive incoming connections
socket – open a local or network socket
setsockopt – define options for an active socket

$ strace -e poll,select,connect,recvfrom,sendto nc www.news.com 80
$ strace -e trace=network

# memory common syscalls:
mmap
munmap

$ strace -e trace=memory

# useful options and examples:
-c – See what time is spend and where (combine with -S for sorting)
-f – Track process including forked child processes
-o my-process-trace.txt – Log strace output to a file
-p 1234 – Track a process by PID
-P /tmp – Track a process when interacting with a path
-T – Display syscall duration in the output

# track by specific syscall group:
-e trace=ipc – Track communication between processes (IPC)
-e trace=memory – Track memory syscalls
-e trace=network – Track memory syscalls
-e trace=process – Track process calls (like fork, exec)
-e trace=signal – Track process signal handling (like HUP, exit)
-e trace=file – Track file related syscalls

# trace multiple syscalls:
strace -e open,close
{% endhighlight %}

### Linux System Errors Types
{% highlight bash %}
cat /usr/include/asm-generic/errno.h |grep "#"
{% endhighlight %}

### Auditd
{% highlight bash %}
# create rule: open
auditctl -a always,exit -F arch=b64 -F pid=8175 -S open -k cups-open-files
ausearch -k cups-open-files

# check which process is modifying a certain directory or file
auditctl -w /path/to/directory -p war
ausearch -f /path/to/directory
{% endhighlight %}

### MySQL version from an FRM file
{% highlight bash %}
# MySQL version 5.5.32
$ hexdump -s 0x33 -n 2 -v -d 55_test.frm
0000033 50532
# MySQL version 5.1.73
$ hexdump -s 0x33 -n 2 -v -d 51_test.frm
0000033 50173
{% endhighlight %}

### Check if a library is installed
{% highlight bash %}
$ ldconfig -p | grep libjpeg
{% endhighlight %}

### FS in File
{% highlight bash %}
$ dd if=/dev/zero of=/tmp/disk-image count=20480
$ mkfs -t ext4 -q /tmp/disk-image
$ mkdir /virtual-fs
$ mount -o loop=/dev/loop0 /tmp/disk-image /virtual-fs
# add to /etc/fstab
/tmp/disk-image /virtual-fs ext4 rw,loop 0 0
{% endhighlight %}

### Encrypt Tar with OpenSSL\GPG
{% highlight bash %}
# encrypt
$ gpg -c test.tar
$ tar -czv stuff|openssl des3 -salt -k secretpassword | dd of=stuff.des3
# decrypt
$ gpg test.tar.gpg
$ dd if=stuff.des3 |openssl des3 -d -k secretpassword|tar xz
{% endhighlight %}

### Split big archive
{% highlight bash %}
split -b 700m archive.tar part
cat part* > archive.tar
{% endhighlight %}

### Installed pkgs size
# freebsd
{% highlight bash %}
pkg_info -as | perl -pe '$/=")"; s/\n*Information for (.*?):[\n\s]*Package Size:[\n\s]*(\d+)\s*\(\s*1K\-blocks\s*\)/$2 - $1\n/;' | sort -nr | less

# ubuntu
dpkg-query -W --showformat='${Installed-Size} ${Package}\n' | sort -n
{% endhighlight %}

### Compare 2 directory
{% highlight bash %}
diff -qr dir1 dir2
{% endhighlight %}

### WGet ALL site
{% highlight bash %}
wget -m -k -nv -np -p --user-agent="Mozilla/5.0 (compatible; Konqueror/3.0.0/10; Linux)" http://www.rhd.ru/docs/manuals/enterprise/RHEL-5-Manual/Virtual-Server-Administration/
{% endhighlight %}

### Mount with SSH
{% highlight bash %}
apt-get install sshfs
mkdir ~/music
sshfs <remote_ip>:/music ~/music/
fusermount -u ~/music/
{% endhighlight %}

### Boot in DOS
{% highlight bash %}
apt-get install syslinux
cp /usr/share/syslinux/memdisk /boot
wget -O /boot/Dos6.22.img http://www.allbootdisks.com/downloads/Disks/MS-DOS_Boot_Disk_Download47/Diskette%20Images/Dos6.22.img
# add to /boot/grub/menu.lst
title MSDOS
root(hd0,0) # Номер диска изменить на нужный
kernel /memdisk
initrd /Dos6.22.img
{% endhighlight %}

### Remove all tables from MySQL DB
{% highlight bash %}
mysql -u root -ppassword -Ddb-name -e 'show tables;' | grep -v 'Tables_in' > /tmp/tables_list
for table in `cat /tmp/tables_list`; do mysql -u root -ppassword -Ddb-name -e "drop table $table;" ; done
{% endhighlight %}

### Resize jpg for web
{% highlight bash %}
for i in *.jpg; do convert -resize 640x480 -quality 85 $i small-$i.jpg; done
{% endhighlight %}

### Postfix redirect outbound mail
{% highlight bash %}
# all outbound mail redirect to local <username>
$ postconf -e luser_relay=username
$ postmap /etc/postfix/transport
$ postconf -e transport_maps=hash:/etc/postfix/transport
# add to /etc/postfix/transport
localhost :
* local:username
{% endhighlight %}

### RM: Argument list too long
{% highlight bash %}
find | xargs --no-run-if-empty -n 500 rm -f
{% endhighlight %}

### Rootkits check
{% highlight bash %}
apt-get install rkhunter
rkhunter –-update
rkhunter –-check
{% endhighlight %}

### Restore deleted files
{% highlight bash %}
lsof | grep storage.db
memcached 22073 memcachedb   15u      REG                8,1 88090279936   14221332 /path/memcachedb/storage.db (deleted)
/proc/22073/fd
find /path/memcachedb/ -inum 14221332 -exec cp {} /var/tmp/storage.db \;
{% endhighlight %}

### Flush linux disk cache
{% highlight bash %}
sudo sh -c 'sync; echo 3 > /proc/sys/vm/drop_caches'
free && sync && echo 3 > /proc/sys/vm/drop_caches && free
{% endhighlight %}
