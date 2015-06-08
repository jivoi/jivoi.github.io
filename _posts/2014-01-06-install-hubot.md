---
layout: post
title: "Install hubot on Ubuntu"
modified: 2014-01-06 12:43:49 +0300
category: [howto]
tags: [linux, ubuntu, hubot]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---
How to install Hubot to Ubuntu linux.

What is Hubot: [Awesome bot for everything](https://hubot.github.com/)

### Add new user and install NVM
{% highlight bash %}
useradd -m hubot
su - hubot
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.24.1/install.sh | bash
nvm install 0.10
{% endhighlight %}

### Install HUBOT
{% highlight bash %}
npm install  generator-hubot yo coffee-script hubot hubot-xmpp
yo hubot --defaults
{% endhighlight %}

### Connect Hubot to XMPP Room
{% highlight bash %}
cat <<EOF > /etc/init/hubot.conf
# hubot - xmpp bot
description "Hubot XMPP bot"
env HUBOT_LOG_LEVEL="debug"
env HUBOT_XMPP_HOST="xmppserver.com"
env HUBOT_XMPP_USERNAME="XMPPACC"
env HUBOT_XMPP_PASSWORD="XMPPPASS"
env HUBOT_XMPP_ROOMS='XMPPROOM@conference.xmppserver.com:roompassword'
env HUBOT_XMPP_PORT="5222"

start on filesystem or runlevel [2345]
stop on runlevel [!2345]

env HUBOT_DIR="/home/hubot/"
env HUBOT="bin/hubot"
env HUBOT_ARGS="-a xmpp"
env HUBOT_USER='hubot' # system account
env HUBOT_NAME='hubot' # what hubot listens to

respawn
respawn limit 5 60
exec start-stop-daemon --start --chuid ${HUBOT_USER} --chdir ${HUBOT_DIR} --exec ${HUBOT_DIR}${HUBOT} -- $HUBOT_ARGS >> /home/hubot/hubot.log 2>&1
EOF
{% endhighlight %}

### Configure Hubot scripts
{% highlight bash %}
cat /home/hubot/hubot-scripts.json
["shipit.coffee", "sudo.coffee", "9gag.coffee", "abstract.coffee", "commandlinefu.coffee", "xkcd.coffee", "yoda-quotes.coffee"]
{% endhighlight %}
More scripts: [LINK](https://github.com/hubot-scripts)

### Start Hubot
{% highlight bash %}
start hubot
tail -f /home/hubot/hubot.log
{% endhighlight %}