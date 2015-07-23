---
layout: post
title: "Learning Android"
modified: 2015-07-17 19:26:55 +0300
category: [howto]
tags: [android,linux]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---
Playing with Android OS

### List of usefull software applications:
- [Android SDK](https://developer.android.com/sdk/index.html)
- [APKTool](https://code.google.com/p/android-apktool/downloads/list)
- [JD-GUI](http://jd.benow.ca/)
- [Dex2Jar](https://github.com/pxb1988/dex2jar)
- [Burp Proxy](http://portswigger.net/burp/download.html)
- [Andriller](http://android.saz.lt/cgi-bin/download.py)
- [Python 3.0](http://python.org/download/releases/3.0/)
- [AFLogical](https://github.com/viaforensics/android-forensics)
- [SQLite Browser](https://github.com/sqlitebrowser/sqlitebrowser)
- [Drozer](https://www.mwrinfosecurity.com/products/drozer/community-edition/)

### Links
- [https://mobilesecuritywiki.com/](https://mobilesecuritywiki.com/)
- [https://manifestsecurity.com/](https://manifestsecurity.com/)

{%img http://elinux.org/images/c/c2/Android-system-architecture.jpg %}

The architecture of Android is divided into four different layers.
At the bottom of it sits the Linux kernel, which has been modified for better performance in a mobile environment.

On top of Linux kernel sits a layer that contains some of the most important and useful libraries as follows:

- Surface Manager: This manages the windows and screens
- Media Framework: This allows the use of various types of codecs for playback and recording of different media
- SQLite: This is a lighter version of SQL used for database management
- WebKit: This is the browser rendering engine
- OpenGL: This is used to render 2D and 3D contents on the screen properly

No libc, Android has its own library called bionic, which we could think of as a stripped down and modified version of libc for Android. All the applications in Android run under a virtual environment, which is called Dalvik Virtual Machine (DVM). An important point to note here is that from Android Version 4.4, there is also the availability of another runtime called Android Runtime (ART), and the user is free to switch between the DVM and the ART
runtime environments.

Dalvik Virtual Machine is similar to Java Virtual Machine (JVM), apart from features such as it is register-based, instead of stack-based. If we are running three different applications, there will be three different virtual instances. The Dalvik Virtual Machine executes a file format called .dex or Dalvik Executable.

### Playing with Android Debug Bridge (ADB)
Enable USB Debugging on your phone or device:
Go to Settings --> About Phone tap "Build Number" until you get a popup that you have become a developer (about 10 times). Then go to Settings --> Developer --> USB debugging and enable it.

{% highlight bash %}
$ adb devices
$ adb shell
$ shell@hammerhead:/ $ ps
$ adb devices
$ adb shell pm list packages
$ dumpsys meminfo
$ adb logcat -d -f /data/local/logcats.log

# print the properties of the device
adb shell getprop

# pm to list all the packages
adb shell pm list packages

# take a backup of any application we need
adb backup [package name] -f [destination file name]
dd if=aplication.ab bs=24 skip=1 | openssl zlib -d > application.tar
tar xzf application.tar

# dumping and analyze application databases manually
the application files are stored at  /data/data/[application package name]/
find /data/data/* -name "*.db" -type f
find /data/data/* -name "*.db" -type f -exec cp {} /mnt/sdcard/BackupDBS \;

# run avd from cli
$ emulator -avd [name of the avd] -http-proxy 127.0.0.1:808
{% endhighlight %}

Every time a new application is initiated in the Android device, it is assigned a unique User ID (UID), which will further belong to some or the other group that is pre-defined. The groups and the permissions inside it are specified in the file in our device named  platform.xml located at  /system/etc/permissions/.

The applications data that we install from the Play Store or any other source will be located at  /data/data , whereas their original installation file, that is, .apk will be stored at  /data/app. Also, there are some applications that need to be purchased from the Play Store instead of just downloading it for free. These applications will be stored at  /data/app-private/. To list this dir you need to be a root. Rooting a device means we have full access and control over the entire device, which means we could see as well as modify any files we wish

An Android application permissions specified in a file called  AndroidManifest.xml. This file contains a list of various application-related information such as the minimum Android version required to run the program, the package name, the list of activities (screens in the application visible to the user), services (background processes of the application), and permissions required.

There is no Certificate Authority; instead the developers self-created certificate could sign the applications. Once the application has been uploaded, it goes for verification to Google Bouncer, which is a virtual environment created to check whether an application is malicious or legitimate. Once the check is done, the app then appears in the Play Store. Google does no signing of the application in this case.

We could check the signature of the application and find out who signed the application:
{% highlight bash %}
$ jarsigner -verify -certs -verbose testing.apk
# or parse out the ASCII content of the CERT.RSA file
$ unzip testing.apk
$ cd META-INF
$ openssl pkcs7 -in CERT.RSA -print_certs -inform DER -out out.cer
$ cat out.cer
{% endhighlight %}

The bootloader boots up the kernel, and launches  init , it mounts some of the important directories required for the functioning of the Android system such as  /dev, /sys, and /proc. Also, init takes the configuration for itself from the configuration files  init.rc and  init.[device-name].rc

We can get specific information about the device, by checking the build.prop file at /system location

Once everything is loaded,  init finally loads up a process known as Zygote, which is responsible for loading up the Dalvik Virtual Machines with shared libraries and minimum footprint to enable faster loading of the overall processes.

An Android application is an archive file of the data and resource files created.
while developing the application. The extension of an Android application is .apk, meaning application package, which includes the following files and folders in most cases:

- Classes.dex (file)
- AndroidManifest.xml (file)
- META-INF (folder)
- resources.arsc (file)
- res (folder)
- assets (folder)
- lib (folder)

An Android application consists of various components: Activities, Services, Broadcast, Receivers, Content providers, and Shared Preferences.
We cant simply unzip the archive package ( .apk ) and get the readable sources.

To convert byte codes to readable files is using a tool called dex2jar:
{% highlight bash %}
# open converted jar with JD-GUI to see source code
http://jd.benow.ca/

# converting the .dex file to smali file
https://code.google.com/p/smali/w/list

# decompiling application using Apktool
$ apktool d WhatsApp.apk

# defining application content provider  AndroidManifest.xml
<provider
android:name="com.test.example.DataProvider"
android:authorities ="com.test.example.DataProvider">
</provider>

# install apk with adb
$ adb install app.apk
{% endhighlight %}
