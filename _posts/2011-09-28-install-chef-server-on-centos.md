--- 
title: Устанавливаем Chef-Server и Chef-Client на CentOS 6
layout: post
syntax-highlighting: yes
excerpt: Набор команд которые нужно выполнть чтобы все заработало на CentOS 6
tags:
- chef-server 
- chef-client
---
<p><img src='http://jivoi.github.io/images/blog/chef.jpg' alt='chef' /></p>

Если кто не знает Chef - это CMT (configuration management tool) написан на ruby.

Набор команд которые нужно выполнть чтобы все заработало на CentOS 6.
Ставить будем на x64, но все это также будет работать и на i386.
Поехали.

**Chef-Client:**

+# Ставим нужные пакеты+

rpm -Uvh http://rbel.co/rbel6
yum install rubygem-chef

+# Настраиваем конфиг клиента+

cat > /etc/chef/client.rb <<-EOF

log_level                :info
log_location             STDOUT
node_name                'node.test.ru'
client_key               '/etc/chef/client.pem'
interval                '300'   
validation_client_name   'chef-validator'
validation_key           '/etc/chef/validation.pem'
chef_server_url          'http://servers.test.ru:4000'
cache_type               'BasicFile'
cache_options( :path => '/etc/chef/checksums' )

EOF

запускать /etc/init.d/chef-client только после установки Chef-Server!

+# Правим iptables+

# Chef
# -- web interface
$IPT -A INPUT -p tcp --dport 4040 -j ACCEPT
# -- chef-server
$IPT -A INPUT -p tcp --dport 4000 -j ACCEPT
# -- amqp server
$IPT -A INPUT -p tcp -m multiport --dport 5672,4369,50229 -j ACCEPT
# -- search indexes (solr)
$IPT -A INPUT -p tcp --dport 8983 -j ACCEPT
# data store (couchdb)
$IPT -A INPUT -p tcp --dport 5984 -j ACCEPT

**Chef-Server:**

+# Ставим нужные пакеты+

rpm -Uvh http://rbel.co/rbel6
yum install rubygem-chef-server

+# Запускаем скрипт настройки+

setup-chef-server.sh

+# Правим iptables+

# Chef
# -- web interface
$IPT -A INPUT -p tcp --dport 4040 -j ACCEPT
# -- chef-server
$IPT -A INPUT -p tcp --dport 4000 -j ACCEPT
# -- amqp server
$IPT -A INPUT -p tcp -m multiport --dport 5672,4369,50229 -j ACCEPT
# -- search indexes (solr)
$IPT -A INPUT -p tcp --dport 8983 -j ACCEPT
# data store (couchdb)
$IPT -A INPUT -p tcp --dport 5984 -j ACCEPT

+# Перезапускам демонов+

/etc/init.d/chef-server restart
/etc/init.d/chef-server-webui restart

+# Копируем приватный ключи на клиентa+

scp /etc/chef/validation.pem login@client.test.ru:/etc/chef/validation.pem

+# Настраиваем knife+

knife configure -i

+# Смотрим в админку+

http://your-chef-server:4040


**Полезные ссылки:**
"Opscode Open Source Wiki":http://wiki.opscode.com/display/chef/Home
"Chef Tutorial":http://blog.afistfulofservers.net/post/3902042503/a-brief-chef-tutorial-from-concentrate
