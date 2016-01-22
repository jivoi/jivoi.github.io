---
layout: post
title: "Linux SysAdm/DevOps Interview Questions"
modified: 2016-01-22 17:13:26 +0300
category: [career]
tags: [linux, sysadm, hr]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---

A collection of Linux SysAdm/DevOps interview questions with my answers

<section id="table-of-contents" class="toc">
<header>
<h3>Contents</h3>
</header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section><!-- /#table-of-contents -->

[SOURCE](https://github.com/chassing/linux-sysadmin-interview-questions)

{% highlight bash %}
{% endhighlight %}

###[[⬆]]General Questions:

* What did you learn yesterday/this week?
* Talk about your preferred development/administration environment. (OS, Editor, Browsers, Tools etc.)
* Tell me about the last major Linux project you finished.
* Tell me about the biggest mistake you've made in [some recent time period] and how you would do it differently today. What did you learn from this experience?
* Why we must choose you?
* What function does DNS play on a network?
* What is HTTP?
* What is an HTTP proxy and how does it work?
* Describe briefly how HTTPS works.
* What is SMTP? Give the basic scenario of how a mail message is delivered via SMTP.
* What is RAID? What is RAID0, RAID1, RAID5, RAID10?
* What is a level 0 backup? What is an incremental backup?
* Describe the general file system hierarchy of a Linux system.


###[[⬆]]Simple Linux Questions:

* What is the name and the UID of the administrator user?
* How to list all files, including hidden one, in a directory?
* What is the Unix/Linux command to remove a directory and its contents?
* Which command will show you free/used memory? Does free memory exist on Linux?
* How to search for the string "my konfi is the best" in files of a directory recursively?
* How to connect to a remote server or what is SSH?
* How to get all environment variables and how can you use them?
* I get "command not found" when I run ```ifconfig -a```. What can be wrong?
* What happens if I type TAB-TAB?
* What command will show the available disk space on the Unix/Linux system?
* What commands do you know that can be used to check DNS records?
* What Unix/Linux commands will alter a files ownership, files permissions?
* What does ```chmod +x FILENAME```do?
* What does the permission 0750 on a file mean?
* What does the permission 0750 on a directory mean?
* How to add a new system user without login permissions?
* How to add/remove a group from a user?
* What is a bash alias?
* How do you set the mail address of the root/a user?
* What does CTRL-c do?
* What is in /etc/services?
* How to redirect STDOUT and STDERR in bash? (> /dev/null 2>&1)
* What is the difference between UNIX and Linux.
* What is the difference between Telnet and SSH?
* Explain the three load averages and what do they indicate.


###[[⬆]]Medium Linux Questions:

* What do the following commands do and how would you use them?
 * ```tee```
 * ```awk```
 * ```tr```
 * ```cut```
 * ```tac```
 * ```curl```
 * ```wget```
 * ```watch```
 * ```head```
 * ```tail```
* What does a ```&``` after a command do?
* What does ```& disown``` after a command do?
* What is a packet filter and how does it work?
* What is Virtual Memory?
* What is swap and what is it used for?
* What is an A record, an NS record, a PTR record, a CNAME record, an MX record?
* Are there any other RRs and what are they used for?
* What is a Split-Horizon DNS?
* What is the sticky bit?
* What does the immutable bit to a file?
* What is the difference between hardlinks and symlinks? What happens when you remove the source to a symlink/hardlink?
* What is an inode and what fields are stored in an inode?
* Howto force/trigger a file system check on next reboot?
* What is SNMP and what is it used for?
* What is a runlevel and how to get the current runlevel?
* What is SSH port forwarding?
* What is the difference between local and remote port forwarding?
* What are the steps to add a user to a system without using useradd/adduser?
* What is MAJOR and MINOR numbers of special files?
* Describe a scenario when you get a "filesystem is full" error, but 'df' shows there is free space.
* Describe a scenario when deleting a file, but 'df' not showing the space being freed.
* Describe how 'ps' works.
* What happens to a child process that dies and has no parent process to wait for it and what’s bad about this?
* Explain briefly each one of the process states.
* How to know which process listens on a specific port?
* What is a zombie process and what could be the cause of it?
* You run a bash script and you want to see its output on your terminal and save it to a file at the same time. How could you do it?
* Explain what echo "1" > /proc/sys/net/ipv4/ip_forward does.
* Describe briefly the steps you need to take in order to create and install a valid certificate for the site https://foo.example.com.
* Can you have several HTTPS virtual hosts sharing the same IP?
* What is a wildcard certificate?
* Which Linux file types do you know?
* What is the difference between a process and a thread? And parent and child processes after a fork system call?
* What is the difference between exec and fork?
* What is "nohup" used for?
* What is the difference between these two commands?
 * ```myvar=hello```
 * ```export myvar=hello```
* How many NTP servers would you configure in your local ntp.conf?
* What does the column 'reach' mean in ```ntpq -p``` output?
* You need to upgrade kernel at 100-1000 servers, how you would do this?
* How can you get Host, Channel, ID, LUN of SCSI disk?
* How can you limit process memory usage?


###[[⬆]]Hard Linux Questions:

* What is a tunnel and how you can bypass a http proxy?
* What is the difference between IDS and IPS?
* What shortcuts do you use on a regular basis?
* What is the Linux Standard Base?
* What is an atomic operation?
* Your freshly configured http server is not running after a restart, what can you do?
* What kind of keys are in ~/.ssh/authorized_keys and what it is this file used for?
* I've added my public ssh key into authorized_keys but I'm still getting a password prompt, what can be wrong?
* Did you ever create RPM's, DEB's or solaris pkg's?
* What does ```:(){ :|:& };:``` do on your system?
* How do you catch a Linux signal on a script?
* Can you catch a SIGKILL?
* What's happening when the Linux kernel is starting the OOM killer and how does it choose which process to kill first?
* Describe the linux boot process with as much detail as possible, starting from when the system is powered on and ending when you get a prompt.
* What's a chroot jail?
* When trying to umount a directory it says it's busy, how to find out which PID holds the directory?
* What's LD_PRELOAD and when it's used?
* You ran a binary and nothing happened. How would you debug this?
* What are cgroups? Can you specify a scenario where you could use them?


###[[⬆]]Expert Linux Questions:

* A running process gets ```EAGAIN: Resource temporarily unavailable``` on reading a socket. How can you close this bad socket/file descriptor without killing the process?


###[[⬆]]Networking Questions:

* What is localhost and why would ```ping localhost``` fail?
* What is the similarity between "ping" & "traceroute" ? How is traceroute able to find the hops.
* What is the command used to show all open ports and/or socket connections on a machine?
* Is 300.168.0.123 a valid IPv4 address?
* Which IP ranges/subnets are "private" or "non-routable" (RFC 1918)?
* What is a VLAN?
* What is ARP and what is it used for?
* What is the difference between TCP and UDP?
* What is the purpose of a default gateway?
* What is command used to show the routing table on a Linux box?
* A TCP connection on a network can be uniquely defined by 4 things. What are those things?
* When a client running a web browser connects to a web server, what is the source port and what is the destination port of the connection?
* How do you add an IPv6 address to a specific interface?
* You have added an IPv4 and IPv6 address to interface eth0. A ping to the v4 address is working but a ping to the v6 address gives yout the response ```sendmsg: operation not permitted```. What could be wrong?
* What is SNAT and when should be used?
* Explain how could you ssh login into a Linux system that DROPs all new incomming packets using a SSH tunnel.
* How do you stop a DDoS?
* How can you see content of ip packet?


###[[⬆]]MySQL questions:

* How do you create a user?
* How do you provide privileges to a user?
* What is the difference between a "left" and a "right" join?
* Explain briefly the differences between InnoDB and MyISAM.
* Describe briefly the steps you need to follow in order to create a simple master/slave cluster.
* Why should you run "mysql_secure_installation" after installing MySQL?
* How do you check which jobs are running?


###[[⬆]]DevOps Questions:

* Can you describe your workflow when you create a script?
* What is GIT?
* What is a dynamically/statically linked file?
* What does "configure && make && make install" do?
* What is puppet/chef/ansible used for?
* How do you create a new postgres user?
* What is a virtual IP address? What is a cluster?
* How do you print all strings of printable characters present in a file?
* How do you find shared library dependencies?
* What is Automake and Autoconf?
* ./configure shows an error that libfoobar is missing on your system, how could you fix this, what could be wrong?
* What are the Advantages/disadvantages of script vs compiled program?
* What's the relationship between continuous delivery and DevOps?
* What are the important aspects of a system of continous integration and deployment?


###[[⬆]]Fun Questions:

* A careless sysadmin executes the following command: ```chmod 444 /bin/chmod ``` - what do you do to fix this?
* I've lost my root password, what can I do?
* I've rebooted a remote server but after 10 minutes I'm still not able to ssh into it, what can be wrong?
* If you were stuck on a desert island with only 5 command-line utilities, which would you choose?
* You come across a random computer and it appears to be a command console for the universe. What is the first thing you type?
* Tell me about a creative way that you've used SSH?
* You have deleted by error a running script, what could you do to restore it?


###[[⬆]]Demo Time:

* Unpack test.tar.gz without man pages or google.

{% highlight bash %}
$ tar xzvf test.tar.gz
{% endhighlight %}

* Remove all "*.pyc" files from testdir recursively?

{% highlight bash %}
$ find ./testdir -type f -name "*.pyc"|xargs rm -f
{% endhighlight %}

* Search for "my konfu is the best" in all *.py files.

{% highlight bash %}
$ find ./testdir -type f -name "*.py"|xargs grep "my konfu is the best"
{% endhighlight %}

* Replace the occurrence of "my konfu is the best" with "I'm a linux jedi master" in all *.txt files.

{% highlight bash %}
$ find ./testdir -type f -name "*.txt"|xargs sed -i "s/my konfu is the best/I\'m a linux jedi master/"
{% endhighlight %}

* Test if port 443 on a machine with IP address X.X.X.X is reachable.

{% highlight bash %}
$  nc -z -v X.X.X.X 443
Connection to X.X.X.X 443 port [tcp/https] succeeded!
{% endhighlight %}

* Get http://myinternal.webserver.local/test.html via telnet.

{% highlight bash %}
$ telnet myinternal.webserver.local 80
GET /test.html HTTP/1.1
HOST: myinternal.webserver.local
<ENTER>
<ENTER>
{% endhighlight %}

* How to send an email without a mail client, just on the command line?

{% highlight bash %}
$ telnet localhost smtp
HELO example.com
mail from: sender@example.com
rcpt to: user@example.com
data
354 Enter mail, end with "." on a line by itself
Hey
This is test email only

Thanks
.
quit

or

$ mail -s "Test Subject" user@example.com
{% endhighlight %}

* Write a ```get_prim``` method in python/perl/bash/pseudo.

{% highlight bash %}
I don`t undestand what is get_prim method, if you know, write a comment plz.
{% endhighlight %}

* Find all files which have been accessed within the last 30 days.

{% highlight bash %}
$ find /* -type f -atime -30
"-30" means that it was accessed "less than 30 days ago"
"+30" means that it was accessed "more than 30 days ago"
{% endhighlight %}

* Explain the following command ```(date ; ps -ef | awk '{print $1}' | sort | uniq | wc -l ) >> Activity.log```

{% highlight bash %}
$ date ; ps -ef | awk '{print $1}' | sort | uniq | wc -l

Execute date command which print current datetime, then we execute process list command and print only UID column, than with pipe we sort it and print only uniq values, after wc -l is counting it number after all we append this to file Activity.log

If file we will see something like this:
Fri Jan 22 15:24:07 UTC 2016
6
{% endhighlight %}

* Write a script to list all the differences between two directories.

{% highlight bash %}
#!/bin/sh
usage="Usage: $0 DIR1 DIR2"

if [ $# -gt 2 ]; then
       echo $usage;
       exit 1
fi

if [ -z "$1" ]; then
        echo $usage;
fi

if [ -d "$1" -a -d "$2" ]; then
        echo "Comparing $1 with $2........"
        diff -r $1 $2
fi
{% endhighlight %}

* In a log file with contents as ```<TIME> : [MESSAGE] : [ERROR_NO] - Human readable text``` display summary/count of specific error numbers that occured every hour or a specific hour.

{% highlight bash %}
$ cat log | awk -F ":" '{print $3}'|sort -n |uniq -c
$ cat log | grep "specific hour" | awk -F ":" '{print $3}'|sort -n |uniq -c
{% endhighlight %}