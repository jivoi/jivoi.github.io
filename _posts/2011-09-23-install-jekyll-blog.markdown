--- 
title: Используем Jekyll + Github для блога 
layout: post
excerpt: Небольшое руководство как запустить блог на github.com и jekyll
syntax-highlighting: yes
tags:
- jekyll
---
Небольшое руководство как запустить блог на github.com и jekyll.

**Команды:** 

{% highlight bash %}
sudo pacman -S git
bash < <(curl -s https://rvm.beginrescueend.com/install/rvm)
rvm install 1.9.2
gem install jekyll
gem install RedCloth
easy_install Pygments
git config --global user.name "user"
git config --global user.email mail@gmail.com
mkdir blog
cd blog
git clone git@github.com:jivoi/jivoi.github.io.git
rake post
rake deploy
{% endhighlight %}

Полезные ссылки:

[https://github.com/mojombo/jekyll/wiki] (https://github.com/mojombo/jekyll/wiki) <br/>
[http://klen.github.com/github-blog-ru.html](http://klen.github.com/github-blog-ru.html) <br/>
[http://blog.envylabs.com/2009/08/publishing-a-blog-with-github-pages-and-jekyll/](http://blog.envylabs.com/2009/08/publishing-a-blog-with-github-pages-and-jekyll/) <br/>
[http://pyobject.ru/blog/2010/04/15/static-blog-generators/](http://pyobject.ru/blog/2010/04/15/static-blog-generators/) <br/>
[http://habrahabr.ru/blogs/webdev/93499/](http://habrahabr.ru/blogs/webdev/93499/) <br/>

