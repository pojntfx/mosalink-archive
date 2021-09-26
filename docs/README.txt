#Commands used to establish a MOSALINK

#You will have to edit some commands to fit your specific system. See the full manual for that.

#1.2.3 Downloads

pojntfx@AlphaINSPIRON510m:~$ sudo apt update
pojntfx@AlphaINSPIRON510m:~$ sudo apt upgrade
pojntfx@AlphaINSPIRON510m:~$ sudo apt install soundmodem libax25 ax25-apps ax25mail-utils ax25-tools ax25-xtools git batctl bridge-utils openssh-server openssh-client xterm

#2 Setup

pojntfx@AlphaINSPIRON510m:~$ cat /proc/asound/cards
pojntfx@AlphaINSPIRON510m:~$ sudo soundmodemconfig

# Insert GUI IMGs here (for node a and b) and description for BOTH nodes

pojntfx@AlphaINSPIRON510m:~$ sudo su

# for node a
root@AlphaINSPIRON510m:/home/pojntfx# sudo echo "1      ALPHAIN510M        1200   255     7       149 MHz (1200 bps)" >>  /etc/ax25/axports

#for node b
root@AlphaINSPIRON510m:/home/pojntfx# sudo echo "1      ALPHANC10        1200   255     7       149 MHz (1200 bps)" >>  /etc/ax25/axports

root@AlphaINSPIRON510m:/home/pojntfx# exit
pojntfx@AlphaINSPIRON510m:~$ alsamixer

# Insert GUI IMG here

pojntfx@AlphaINSPIRON510m:~$ sudo service smbd stop
pojntfx@AlphaINSPIRON510m:~$ sudo service nmbd stop
pojntfx@AlphaINSPIRON510m:~$ cd ~/
pojntfx@AlphaINSPIRON510m:~$ git clone https://github.com/chazapis/eoax
pojntfx@AlphaINSPIRON510m:~$ sudo nano /etc/apt/sources.list

# Insert GUI IMG here
# Probably a alternative method using echo and grep would be best though
pojntfx@AlphaINSPIRON510m:~$ sudo apt update
pojntfx@AlphaINSPIRON510m:~$ sudo apt-get build-dep linux-image-$(uname -r)
pojntfx@AlphaINSPIRON510m:~$ sudo apt-get source linux-image-$(uname -r)
pojntfx@AlphaINSPIRON510m:~$ ls
Bilder     eoax                        linux_4.10.0-19.21.dsc    Öffentlich    Vorlagen
Dokumente  linux-4.10.0                linux_4.10.0.orig.tar.gz  Schreibtisch
Downloads  linux_4.10.0-19.21.diff.gz  Musik                     Videos
pojntfx@AlphaINSPIRON510m:~$ cd linux-4.10.0
pojntfx@AlphaINSPIRON510m:~/linux-4.10.0$ sudo patch -p0 < ~/eoax/patches/ax25_ui_type-3.19
pojntfx@AlphaINSPIRON510m:~/linux-4.10.0$ sudo cp include/net/ax25.h /usr/src/linux-headers-$(uname -r)/include/net/
pojntfx@AlphaINSPIRON510m:~/linux-4.10.0$ cd net/ax25
pojntfx@AlphaINSPIRON510m:~/linux-4.10.0/net/ax25$ sudo make -C /lib/modules/$(uname -r)/build M=$(pwd) modules
pojntfx@AlphaINSPIRON510m:~/linux-4.10.0/net/ax25$ cd /usr/src/linux-headers-$(uname -r)/certs
pojntfx@AlphaINSPIRON510m:/usr/src/linux-headers-4.10.0-19-generic/certs$ sudo su
root@AlphaINSPIRON510m:/usr/src/linux-headers-4.10.0-19/certs# touch x509.genkey
root@AlphaINSPIRON510m:/usr/src/linux-headers-4.10.0-19/certs# echo "
[ req ]
default_bits = 4096
distinguished_name = req_distinguished_name
prompt = no
string_mask = utf8only
x509_extensions = myexts
[ req_distinguished_name ]
CN = Modules
[ myexts ]
basicConstraints=critical,CA:FALSE
keyUsage=digitalSignature
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid
" >> x509.genkey
root@AlphaINSPIRON510m:/usr/src/linux-headers-4.10.0-19/certs# exit
pojntfx@AlphaINSPIRON510m:/usr/src/linux-headers-4.10.0-19-generic/certs$ sudo openssl req -new -nodes -utf8 -sha512 -days 36500 -batch -x509 -config x509.genkey -outform DER -out signing_key.x509 -keyout signing_key.pem
pojntfx@AlphaINSPIRON510m:/usr/src/linux-headers-4.10.0-19-generic/certs$ sudo /usr/src/linux-headers-$(uname -r)/scripts/sign-file sha512 /usr/src/linux-headers-$(uname -r)/certs/signing_key.pem /usr/src/linux-headers-$(uname -r)/certs/signing_key.x509 ~/linux-4.10.0/net/ax25/ax25.ko
pojntfx@AlphaINSPIRON510m:/usr/src/linux-headers-4.10.0-19-generic/certs$ cd ~/linux-4.10.0/net/ax25
pojntfx@AlphaINSPIRON510m:~/linux-4.10.0/net/ax25$ sudo make -C /lib/modules/$(uname -r)/build M=$(pwd) modules_install
pojntfx@AlphaINSPIRON510m:~/linux-4.10.0/net/ax25$ sudo su
root@AlphaINSPIRON510m:/home/pojntfx/linux-4.10.0/net/ax25# echo "override ax25 * extra" >> /etc/depmod.d/ubuntu.conf
root@AlphaINSPIRON510m:/home/pojntfx/linux-4.10.0/net/ax25# exit

#this is gonna take some time
pojntfx@AlphaINSPIRON510m:~/linux-4.10.0/net/ax25$ sudo depmod

pojntfx@AlphaINSPIRON510m:~/linux-4.10.0/net/ax25$ cp Module.symvers ~/eoax/drivers/net/hamradio/
pojntfx@AlphaINSPIRON510m:~/linux-4.10.0/net/ax25$ cd ~/eoax
pojntfx@AlphaINSPIRON510m:~/eoax$ make
pojntfx@AlphaINSPIRON510m:~/eoax$ sudo make install

# 3 Startup
# 3.1 Soundmodem
pojntfx@AlphaINSPIRON510m:~$ sudo soundmodem
ALSA: Using sample rate 9600, sample format 2, significant bits 16, buffer size 3276, period size 156
ALSA: Using sample rate 9600, sample format 2, significant bits 16, buffer size 3276, period size 156
pojntfx@AlphaINSPIRON510m:~$ ip a
10: ax0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 256 qdisc pfifo_fast state UNKNOWN group default qlen 10
    link/ax25 82:98:a0:90:82:92:00 brd a2:a6:a8:40:40:40:00
    inet 10.0.0.1/24 brd 10.0.0.255 scope global ax0
       valid_lft forever preferred_lft forever
pojntfx@AlphaINSPIRON510m:~$ alsamixer

#insert GUI images here

pojntfx@AlphaINSPIRON510m:~$ sudo service smbd stop
pojntfx@AlphaINSPIRON510m:~$ sudo service nmbd stop

pojntfx@AlphaINSPIRON510m:~$ ping 10.0.0.2 -s 8
PING 10.0.0.2 (10.0.0.2) 8(36) bytes of data.
16 bytes from 10.0.0.2: icmp_seq=1 ttl=64 time=8285 ms
16 bytes from 10.0.0.2: icmp_seq=2 ttl=64 time=7672 ms
16 bytes from 10.0.0.2: icmp_seq=3 ttl=64 time=7006 ms
16 bytes from 10.0.0.2: icmp_seq=4 ttl=64 time=6372 ms
16 bytes from 10.0.0.2: icmp_seq=5 ttl=64 time=5705 ms

# 3.2 Eoax
pojntfx@AlphaINSPIRON510m:~$ sudo depmod
pojntfx@AlphaINSPIRON510m:~$ sudo modprobe eoax
pojntfx@AlphaINSPIRON510m:~$ sudo ip link set eoax0 down
pojntfx@AlphaINSPIRON510m:~$ sudo ip link set eoax0 up
pojntfx@AlphaINSPIRON510m:~$ sudo avahi-autoipd eoax0
pojntfx@AlphaINSPIRON510m:~$ ip a
11: eoax0: <BROADCAST,UP,LOWER_UP> mtu 1280 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 82:98:a0:90:82:92 brd ff:ff:ff:ff:ff:ff
    inet 169.254.9.107/16 brd 169.254.255.255 scope link eoax0:avahi
       valid_lft forever preferred_lft forever11: eoax0: <BROADCAST,UP,LOWER_UP> mtu 1280 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 82:98:a0:90:82:92 brd ff:ff:ff:ff:ff:ff
    inet 169.254.9.107/16 brd 169.254.255.255 scope link eoax0:avahi
pojntfx@AlphaINSPIRON510m:~$ ping 169.254.9.157 -s 8
pojntfx@AlphaINSPIRON510m:~$ ping 169.254.9.157 -s 8
PING 169.254.9.157 (169.254.9.157) 8(36) bytes of data.
16 bytes from 169.254.9.157: icmp_seq=1 ttl=64 time=11862 ms
16 bytes from 169.254.9.157: icmp_seq=2 ttl=64 time=11292 ms
16 bytes from 169.254.9.157: icmp_seq=3 ttl=64 time=10755 ms
16 bytes from 169.254.9.157: icmp_seq=4 ttl=64 time=10154 ms
16 bytes from 169.254.9.157: icmp_seq=5 ttl=64 time=9617 ms

# 3.3 Batman-adv
pojntfx@AlphaINSPIRON510m:~$ sudo modprobe batman-adv
pojntfx@AlphaINSPIRON510m:~$ sudo batctl if add eoax0
pojntfx@AlphaINSPIRON510m:~$ sudo ip link set dev bat0 down
pojntfx@AlphaINSPIRON510m:~$ sudo ip link set dev bat0 up
pojntfx@AlphaINSPIRON510m:~$ sudo avahi-autoipd bat0
pojntfx@AlphaINSPIRON510m:~$ ip a
9: bat0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UNKNOWN group default qlen 1000
    link/ether 06:9e:4a:99:33:8d brd ff:ff:ff:ff:ff:ff
    inet 169.254.7.139/16 brd 169.254.255.255 scope link bat0:avahi
       valid_lft forever preferred_lft forever
    inet6 fe80::49e:4aff:fe99:338d/64 scope link 
       valid_lft forever preferred_lft forever
pojntfx@AlphaINSPIRON510m:~$ sudo  batctl o
[B.A.T.M.A.N. adv 2016.5, MainIF/MAC: eoax0/82:98:a0:90:82:92 (bat0/06:9e:4a:99:33:8d BATMAN_IV)]
   Originator        last-seen (#/255) Nexthop           [outgoingIF]
 * 82:98:a0:90:82:9c    0.208s   ( 49) 82:98:a0:90:82:9c [     eoax0]

