---
layout: post
title: "Playing with Sysdig"
modified: 2015-07-03 18:32:42 +0300
category: [howto]
tags: [sysdig,linux,sysadm]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---
Learn how to use Sysdig

- [Sysdig Site](http://www.sysdig.org/)
- [Sysdig Wiki](http://www.sysdig.org/wiki/)

### First steps with Sysdig
{% highlight bash %}
# install 
curl -s https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public | apt-key add -
curl -s -o /etc/apt/sources.list.d/draios.list http://download.draios.com/stable/deb/draios.list
apt-get update
apt-get -y install linux-headers-$(uname -r)
apt-get -y install sysdig

# capturing and reading events
sysdig -vDw filename
sysdig -vDr filename

# filtering the data
sysdig -l
sysdig -vDr filename  "proc.name=sshd"
sysdig -vDr filename  "proc.name=sshd and evt.type=accept and evt.dir=<"
sysdig -vDr filename  "proc.name=sshd and evt.type=read and evt.dir=<"
sysdig -s 65536 -vSzw nginx.scap "proc.name=nginx"
sysdig -s 65536 -vSzw httpd.scap "proc.name=httpd"
sysdig -r httpd.scap -j -p "%evt.time %fd.directory %fd.filename" "evt.type=open and evt.dir=<"

# analyzing syslog with sysdig
sysdig -c spy_syslog
sysdig -c spy_syslog 'syslog.severity < 4 and proc.name=logger'
sysdig -F -w trace.scap evt.is_syslog=true

# analyzing application logs with sysdig
sysdig -c spy_logs
sysdig -c spy_logs proc.name=httpd and evt.buffer contains GET
sysdig -r system.scap -c spy_logs "request.scap 1000" "evt.buffer contains Database"
-c spy_logs “request.scap 1000″ means: for each event selected, save 1000ms of system activity before it happened and 1000ms of activity after it happened, but just for the thread that generated the event, and save it to request.scap

“evt.buffer contains Database” is our filter for selecting events, which we use to isolate the specific log entry we’re interested in (and in fact, sysdig confirms the success of our filter by showing the one log message we wanted to isolate in this case)

# lsof + filters
sysdig -c lsof "proc.name=sshd"
sysdig -c lsof "'fd.type=ipv4 and user.name=root'"
sysdig -c lsof "'fd.name contains /etc'"
sysdig -c ps "'fd.type=ipv4'"
sysdig -c ps "'fd.name contains /etc or fd.type=ipv4'"

# chisels(Lua scripts)
sysdig -c topprocs_cpu
sysdig -c topprocs_net
sysdig -c topconns
{% endhighlight %}
