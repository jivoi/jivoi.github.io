---
layout: post
title: "ArchLinux Installation Guide"
modified: 2015-12-30 13:17:40 +0300
category: [linux,howto]
tags: [archlinux, howto, admin]
image:
  feature:
  credit:
  creditlink:
comments: True
share:
---

This is MY guide for installing ArchLinux from the official liveCD image.

<section id="table-of-contents" class="toc">
<header>
<h3>Contents</h3>
</header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section><!-- /#table-of-contents -->

{% highlight bash %}
{% endhighlight %}

### Download and Boot
- [Download and boot with CD\USB](https://www.archlinux.org/download/)

### Network Configuration
{% highlight bash %}
ip link set wlp3s0 up
wifi-menu wlp3s0
ip addr
ping -c 3 www.google.com
passwd root
systemctl start sshd
{% endhighlight %}

### Create partitions
{% highlight bash %}
# Remove old partitions then create the following partitions:
# 2MB, type EF02 (BIOS partition). This is used by GRUB2/BIOS-GPT.
# 1000MB, type 0800 (Linux). This will store /boot (/dev/sda2)
# 4GB, type XXX (swap). This is our swap partition. (/dev/sda3)
# Remaining space, type 0800 (Linux). Store both / and /home. (/dev/sda4).
# You can have a separate /home if you prefer.
cgdisk /dev/sda
{% endhighlight %}

### Format and activate partitions
{% highlight bash %}
mkfs.ext4 /dev/sda2
mkswap /dev/sda3 && swapon /dev/sda3
mkfs.ext4 /dev/sda3
mount /dev/sda4 /mnt; mkdir /mnt/boot; mount /dev/sda2 /mnt/boot
mkdir /mnt/home
{% endhighlight %}

### Install the base packages
{% highlight bash %}
pacstrap -i /mnt base base-devel dialog wpa_supplicant
{% endhighlight %}

### Generate fstab
{% highlight bash %}
genfstab -pU /mnt >> /mnt/etc/fstab
echo "tmpfs /tmp    tmpfs   defaults,noatime,mode=1777  0   0" >> /mnt/etc/fstab
{% endhighlight %}

### Enter the new system
{% highlight bash %}
arch-chroot /mnt /bin/bash
{% endhighlight %}

### Set fastmirrors
{% highlight bash %}
pacman -S reflector
reflector -c RU -c FR -c GE --sort rate -p http --save /etc/pacman.d/mirrorlist
{% endhighlight %}

### Setup system clock
{% highlight bash %}
ln -s /usr/share/zoneinfo/Europe/SubZone /etc/localtime
{% endhighlight %}

### Set the hostname
{% highlight bash %}
echo MYHOSTNAME > /etc/hostname
{% endhighlight %}

### Language and location settings
{% highlight bash %}
mv /etc/locale.gen{,.orig}
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
echo 'KEYMAP="us"' >> /etc/vconsole.conf
export LANG=en_US.UTF-8
{% endhighlight %}

### Set root password
{% highlight bash %}
passwd root
{% endhighlight %}

### Add real user
{% highlight bash %}
useradd -m -g users -G audio,lp,optical,storage,video,wheel,power,network -s /bin/bash MYUSERNAME
{% endhighlight %}

### Add user to sudo
{% highlight bash %}
passwd MYUSERNAME
pacman -S sudo
# Uncomment the line '%wheel ALL=(ALL) ALL'
EDITOR=nano; visudo
{% endhighlight %}

### Configure repositories
{% highlight bash %}
nano /etc/pacman.conf
Color

[multilib]
Include = /etc/pacman.d/mirrorlist
[archlinuxfr]
SigLevel = Never
Server = http://repo.archlinux.fr/$arch
[infinality-bundle]
SigLevel = Never
Server = http://bohoomil.com/repo/$arch
[infinality-bundle-fonts]
SigLevel = Never
Server = http://bohoomil.com/repo/fonts

sudo pacman-key -r 962DDE58
sudo pacman-key –lsign-key 962DDE58
pacman -Sy
{% endhighlight %}

### Install grub
{% highlight bash %}
pacman -S grub os-prober
grub-install --target=i386-pc --recheck /dev/sda
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg
{% endhighlight %}

### Wired packages
{% highlight bash %}
pacman -S iw wpa_supplicant dialog wireless_tools wpa_actiond
{% endhighlight %}

### Install OpenSSH
{% highlight bash %}
pacman -S openssh
systemctl enable sshd
nano /etc/ssh/sshd_config
{% endhighlight %}

### Reboot into the new system
{% highlight bash %}
exit
umount -R /mnt
reboot
{% endhighlight %}

### Login and setup network
{% highlight bash %}
sudo wifi-menu -o
sudo netctl enable WIFI_PROFILE
{% endhighlight %}

### Install X
{% highlight bash %}
sudo pacman -S xorg-server xorg-server-utils xorg-xinit libva-intel-driver intel-gpu-tools xf86-video-intel xf86-input-synaptics xorg-twm xorg-xclock xterm
{% endhighlight %}

### KDE5 Plasma
{% highlight bash %}
sudo pacman -S plasma-desktop plasma-nm plasma-pa bluedevil kscreen dolphin dolphin-plugins kdeplasma-addons kdeconnect sddm sddm-kcm kwalletmanager print-manager sni-qt lib32-sni-qt kdegraphics-ksnapshot networkmanager network-manager-applet kde-gtk-config gwenview sni-qt lib32-sni-qt
yaourt -S papirus-icons
yaourt -S breeze-gtk-git
yaourt -S xembed-sni-proxy-git
systemctl set-default graphical.target
systemctl disable kdm.service
systemctl enable sddm.service
systemctl disable dhcpcd.service
systemctl enable NetworkManager.service
systemctl enable cronie.service
{% endhighlight %}

### Sound
{% highlight bash %}
sudo pacman -S alsa-utils alsa-oss
{% endhighlight %}

### Font Rendering
{% highlight bash %}s
sudo pacman -S ttf-ubuntu-font-family ttf-liberation ttf-gentium ttf-droid ttf-bitstream-vera ttf-dejavu ttf-font terminus-font
yaourt -S ttf-ms-fonts ttf-mac-fonts
pacman -Syyu {fontconfig,freetype2,cairo}-infinality-ultimate
cat /etc/fonts/local.conf >  ~/.config/fontconfig/fonts.conf
{% endhighlight %}

### Software
{% highlight bash %}
sudo pacman -S yaourt bash-completion git mercurial subversion cpupower vlc gstreamer0.10-plugins jdk8-openjdk flashplugin ntfs-3g ntfsprogs ntp lshw pm-utils powertop acpid xfsprogs pidgin pidgin-sipe pidgin-libnotify purple-plugin-pack gparted dosfstools ntfsprogs intel-ucode chromium firefox dbus sudo acpi pm-utils vbetool p7zip youtube-dl ntfs-3g transmission-qt net-tools rsync unrar unzip wget zip htop redshift dropbox sublime-text-dev iptables atop clementine curl gsmartcontrol keychain nmap rdesktop screen smartmontools tmux vim workrave moreutils strace lm_sensors kde-wallpapers krusader kde-l10n-ru evince k3b ecryptfs-utils iotop speedtest-cli torsocks hdparm ack konsole plasma-workspace-wallpapers ipython  networkmanager-openvpn openvpn virtualbox x11vnc scrot ecryptfs-utils lsof libreoffice udisks laptop-detect horst colordiff keepass dmidecode archlinux-keyring ark vim-systemd namcap ddrescue testdisk cabextract cpio lzop sshfs fuse ifuse dkms i7z usb_modeswitch gst-plugins-good gst-libav libdvdcss ffmpeg speex x264 x265 xvidcore android-tools gstreamer gst-libav gst-plugins-bad gst-plugins-base gst-plugins-base-libs gst-plugins-good dnsutils wireshark-qt socat tcpflow

yaourt -S chromium-pepper-flash keepass-plugin-http
yaourt -S krop
{% endhighlight %}

### VirtualBox
{% highlight bash %}
sudo pacman -S virtualbox virtualbox-guest-iso linux-headers virtualbox-guest-modules xf86-video-vesa
yaourt virtualbox-ext-oracle
gpasswd -a username vboxusers
# Load module on boot
# Edit /etc/modules-load.d/virtualbox.conf and add: vboxdrv
sudo sh -c 'cat >> /etc/modules-load.d/virtualbox.conf << EOF
vboxguest
vboxsf
vboxvideo
EOF'
{% endhighlight %}

### Printer
{% highlight bash %}
pacman -S cups ghostscript gsfonts
# groupadd -g107 lpadmin
/etc/cups/cups-files.conf
# Administrator user group...
SystemGroup sys root lpadmin

systemctl start org.cups.cupsd.service
systemctl enable org.cups.cupsd.service
systemctl disable org.cups.cupsd.service
{% endhighlight %}

### Reshift
{% highlight bash %}
/usr/bin/redshift -c /dev/null -l 55.8 37.6 -t 5500 3700 -g 1.00 1.00 1.00 -b 1.00
~/.config/redshift.conf
[redshift]
temp-day=5500
temp-night=3700
brightness=1.00
gamma=1.00
location-provider=manual

[manual]
lat=55.6
lon=37.6
{% endhighlight %}

### HDD load cycle count
{% highlight bash %}
sudo hdparm -B 255 /dev/sda

sudo sh -c 'cat >> /etc/udev/rules.d/50-hdparm.rules << EOF
ACTION=="add", SUBSYSTEM=="block", KERNEL=="sda", RUN+="/usr/sbin/hdparm -B 254 -S 0 /dev/sda"
EOF'

sudo sh -c 'cat >> /usr/lib/systemd/system-sleep/hdparm_set << EOF
#!/bin/sh
/usr/sbin/hdparm -B 254 -S 0 /dev/sda
EOF'

chmod +x /usr/lib/systemd/system-sleep/hdparm_set
{% endhighlight %}

### Sysctl
{% highlight bash %}
echo "vm.swappiness=10" >> /etc/sysctl.conf
echo "vm.vfs_cache_pressure=50" >> /etc/sysctl.conf
{% endhighlight %}

### Encrypt User Home with ecryptfs
{% highlight bash %}
echo "ecryptfs" > /etc/modules-load.d/ecryptfs.conf
modprobe ecryptfs
sudo ecryptfs-migrate-home -u login
ecryptfs-mount-private
ecryptfs-umount-private

cat /etc/pam.d/system-auth
#%PAM-1.0

auth      required  pam_unix.so     try_first_pass nullok
auth      required    pam_ecryptfs.so unwrap
auth      optional  pam_permit.so
auth      required  pam_env.so

account   required  pam_unix.so
account   optional  pam_permit.so
account   required  pam_time.so

password  optional    pam_ecryptfs.so
password  required  pam_unix.so     try_first_pass nullok sha512 shadow
password  optional  pam_permit.so

session   required  pam_limits.so
session   required  pam_unix.so
session    optional    pam_ecryptfs.so
session   optional  pam_permit.so

# after login
ecryptfs-unwrap-passphrase
ecryptfs-add-passphrase
# change passpharase
ecryptfs-rewrap-passphrase /home/$USER/.ecryptfs/wrapped-passphrase
{% endhighlight %}

### GRUB2 Speedup
{% highlight bash %}
# /etc/default/grub
GRUB_TIMEOUT=0
GRUB_CMDLINE_LINUX_DEFAULT="quiet loglevel=3 rd.systemd.show_status=false rd.udev.log-priority=3"
GRUB_FORCE_HIDDEN_MENU="true"
grub-mkconfig > /boot/grub/grub.cfg
{% endhighlight %}

### GRUB2 Password
{% highlight bash %}
grub2-mkpasswd-pbkdf2
Enter password:
Reenter password:
PBKDF2 hash of your password is grub.pbkdf2.sha512.10000.SOMEHASH

# change config /etc/grub.d/40_custom
set superusers="root"
password_pbkdf2 root grub.pbkdf2.sha512.10000.SOMEHASH

/etc/grub.d/10_linux
CLASS="--unrestricted"

grub-mkconfig > /boot/grub/grub.cfg
{% endhighlight %}

### Improve ext4 performance
{% highlight bash %}
# - http://menelkir.itroll.org/2011/06/ext4-optimization-for-daily-use.html
# - http://blog.smartlogic.io/2009/06/04/rails-development-mount-options-to-improve-ext4-file-system-performance
#
tune2fs -m 0 /dev/sdX

# add to fstab
# rw,noatime,nouser_xattr,relatime,data=ordered

{% endhighlight %}

### System Speedup
{% highlight bash %}
ln -sfv /run/user/$UID/ /home/$USER/.compose-cache

systemd-analyze blame
systemd-analyze critical-chain

yaourt -S systemd-readahead
systemctl enable systemd-readahead-collect systemd-readahead-replay
systemctl enable upower

# change /etc/systemd/journald.conf
SystemMaxUse=50M
{% endhighlight %}

### Save installed pkg list
{% highlight bash %}
pacman -Qqe | awk '{print $1}' > package_list.txt
{% endhighlight %}

### IPtables rules
{% highlight bash %}
wget https://github.com/jivoi/scripts/raw/master/iptables_rules.sh
# comment localnet rules
./iptables_rules.sh
iptables-save > /etc/iptables/iptables.rules
systemctl enable iptables.service
systemctl start iptables.service
{% endhighlight %}



{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}


{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}

{% highlight bash %}
{% endhighlight %}