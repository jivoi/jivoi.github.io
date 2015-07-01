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
