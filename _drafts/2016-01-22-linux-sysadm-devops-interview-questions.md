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

{% highlight bash %}

{% endhighlight %}

* How do you provide privileges to a user?
* What is the difference between a "left" and a "right" join?
* Explain briefly the differences between InnoDB and MyISAM.
* Describe briefly the steps you need to follow in order to create a simple master/slave cluster.
* Why should you run "mysql_secure_installation" after installing MySQL?
* How do you check which jobs are running?


###[[⬆]]DevOps Questions:

* Can you describe your workflow when you create a script?

{% highlight bash %}
1. Create\check task in tfs\jira
2. Analysis task description.
3. Analysis current script collection.
4. Analysis internet for same job\problem.
5. Write and test script prototype in test environment.
6. Commit script to git\svn
7. Build package\use CMS to deploy script in production.
8. Close task in tfs\jira
{% endhighlight %}

* What is GIT?

{% highlight bash %}
Git is a distributed version control system developed by Linus Torvalds
{% endhighlight %}

* What is a dynamically/statically linked file?

{% highlight bash %}
Statically file means that the linker program (ld) after source code compilation adds all librarys and other dependencies directly to executable file

Dynamically file means that the above step doesn't happen. The operating system's loader needs to find the dependencies code, load it into memory, each time the program is run.
{% endhighlight %}

* What does "configure && make && make install" do?

{% highlight bash %}
This commands is need if you what to build software from source code.

Configure - is a script which is responsible for getting ready to build the software on your specific system. It makes sure all of the dependencies for the rest of the build and install process are available, and finds out whatever it needs to know to use those dependencies.

Make - is a command  which runs a series of tasks defined in a Makefile to build the finished program from its source code.

Make install - is a command which will copy the built program, and its libraries and documentation, to the correct locations.
{% endhighlight %}

* What is puppet/chef/ansible used for?

{% highlight bash %}
Puppet/Chef/Ansible - are a free software platform for configuring and managing computers.
{% endhighlight %}

* How do you create a new postgres user?

{% highlight bash %}
$ psql -c "CREATE USER testuser WITH PASSWORD 'XXXXX';"
{% endhighlight %}

* What is a virtual IP address? What is a cluster?

{% highlight bash %}
A virtual IP address (VIP or VIPA) is an IP address that doesn't correspond to an actual physical network interface (port). Uses for VIPs include Network Address Translation (especially, One-to-many NAT), fault-tolerance, and mobility.

Virtual IP addresses are commonly used to enable high availability. A standard failover design uses an active/passive server pair connected by replication and watched by a cluster manager. The active server listens on a virtual IP address; applications use it for connections instead of the normal host IP address. Should the active server fail, the cluster manager promotes the passive server and shifts the floating IP address to the newly promoted host. Application connections break and then reconnect to the VIP again, which points them to the new server.

Cluster is a set of loosely or tightly connected computers that work together so that, in many respects, they can be viewed as a single system.
{% endhighlight %}

* How do you print all strings of printable characters present in a file?

{% highlight bash %}
Use cmd /usr/bin/strings
$ strings /path/somefile
{% endhighlight %}

* How do you find shared library dependencies?

{% highlight bash %}
ldd - print shared library dependencies
$ ldd /path/somefile
        linux-vdso.so.1 (0x00007ffcdabac000)
        libselinux.so.1 => /lib/x86_64-linux-gnu/libselinux.so.1 (0x00007f1a42081000)
{% endhighlight %}

* What is Automake and Autoconf?

{% highlight bash %}
Automake and Autoconf both are parts of The GNU build system, also known as the Autotools, is a suite of programming tools designed to assist in making source code packages portable to many Unix-like systems.

Automake - is a programming tool to automate parts of the compilation process. It eases usual compilation problems. For example, it points to needed dependencies. It automatically generates one or more Makefile.in from files called Makefile.am. Each Makefile.am contains, among other things, useful variable definitions for the compiled software, such as compiler and linker flags, dependencies and their versions, etc.

Autoconf - generate a configuration script from a TEMPLATE-FILE if given, or configure.ac if present, or else configure.in. Output is sent to the standard output if TEM‐PLATE-FILE is given, else into configure.
{% endhighlight %}

* ./configure shows an error that libfoobar is missing on your system, how could you fix this, what could be wrong?

{% highlight bash %}
Configure could not find libfoobar in LD_LIBRARY_PATH or libfoobar is not installed on your system.
You can fix it by installing libfoobar package with package manager or build it from source.
If libfoobar is already installed just check /etc/ld.so.conf and add right path to libfoobar
{% endhighlight %}

* What are the Advantages/disadvantages of script vs compiled program?

{% highlight bash %}
Script program have the advantages of:
- flexibility to change the script
- easier to implement (writing good compilers is very hard!!)
- no need to run a compilation stage: can execute code directly "on the fly"
- being more portable.

Script program have the disadvantages of:
- much slow than compiled program
- source code is open

Compiled program have the advantages of:
- faster performance by directly using the native code of the target machine
- opportunity to apply quite powerful optimisations during the compile stage
- hides the source code from the end user

Compiled program have the disadvantages of:
- slow to develop (edit, compile, link and run. The compile/link steps could take serious time).
- to execute you need to compile a different executable for each type of processor and/or platform that you want your program to run on
{% endhighlight %}

* What's the relationship between continuous delivery and DevOps?

{% highlight bash %}
Continuous delivery(CD) is an agile way of working whereby quality products—normally software assets—can be developed, built, tested, and shipped in quick succession.
DevOps is another way of working whereby developers and system operators work in harmony with little or no organizational barriers between them towards a common goal.
{% endhighlight %}

* What are the important aspects of a system of continous integration and deployment?

{% highlight bash %}
Automation\testing are the important aspects of a great development workflow.
Every task that can be done by a machine should be.
Automation gives you the time to focus.
Through testing, you can be sure that the most important steps your customers will take through your system are working, regardless of the changes you make.
This gives you the confidence to experiment, implement new features, and ship updates quickly.
{% endhighlight %}

###[[⬆]]Fun Questions:

* A careless sysadmin executes the following command: ```chmod 444 /bin/chmod ``` - what do you do to fix this?

{% highlight bash %}
Default permission is 755.
Y can use C\C++\Python\Perl and other language to fix this.

#!/usr/bin/python
import os
os.chmod("/bin/chmod", 0755)
{% endhighlight %}

* I've lost my root password, what can I do?

{% highlight bash %}
Simple boot in sigle mode and change it.
Change in grub -> init=/bin/bash -> boot -> run $mount -o remount,rw / -> change root password with $ passwd root
{% endhighlight %}

* I've rebooted a remote server but after 10 minutes I'm still not able to ssh into it, what can be wrong?

{% highlight bash %}
If it does not ping, maybe proble with network\firewall
If it pings but you can not to connect to it with ssh maybe problem with ssh config\firewall rules
Bad permission for ssh keys
Wrong password
{% endhighlight %}

* If you were stuck on a desert island with only 5 command-line utilities, which would you choose?

{% highlight bash %}
you do not need computer on a desert island because there is no enegry =)
{% endhighlight %}

* You come across a random computer and it appears to be a command console for the universe. What is the first thing you type?

{% highlight bash %}
It cool to live forever =)
change user 'mylogin' expiration from 'XXXXX-XX-XX' to 'never'
usermod -e "" mylogin
{% endhighlight %}

* Tell me about a creative way that you've used SSH?

{% highlight bash %}
add to .ssh/config this lines and install tor and you can use ssh with tor.
Host *.onion
    ProxyCommand socat - SOCKS4A:localhost:%h:%p,socksport=9050
{% endhighlight %}

* You have deleted by error a running script, what could you do to restore it?

{% highlight bash %}
While script is running it is not deleted
Find pid of running script and restore it from procfs
ls -l /proc/4607/fd/4
lr-x------ 1 juliet juliet 64 Apr  7 03:19
/proc/4607/fd/4 -> /home/juliet/testing.txt (deleted)
$ cp /proc/4607/fd/4 testing.txt.bk
{% endhighlight %}

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