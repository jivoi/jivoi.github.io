---
layout: post
title: "Blogging with github"
modified: 2014-01-01 12:43:49 +0300
category: [blog]
tags: [blog, github]
image:
  feature: 
  credit: 
  creditlink: 
comments: True
share: 
---
Use github and jekyll for blog

### Install RVM
{% highlight bash %}
curl -sSL https://get.rvm.io | bash -s stable --ruby
rvm install 2.1
rvm use 2.1 --default
gem install bundle
{% endhighlight %}

### Clone Github Repo and install Jekyll
{% highlight bash %}
git clone -b develop https://github.com/jivoi/jivoi.github.io.git
cd jivoi.github.io
bundle install
git clone -b master https://github.com/jivoi/jivoi.github.io.git _site
rake new_post
vim _posts/
{% endhighlight %}

### Build and Test
{% highlight bash %}
jekyll b
jekyll s --host 0.0.0.0 --watch
{% endhighlight %}

### Commit and deploy
{% highlight bash %}
git st
git add _posts/*
git push -u origin develop
git commit -a -m "blogging with github"
rake deploy
{% endhighlight %}
