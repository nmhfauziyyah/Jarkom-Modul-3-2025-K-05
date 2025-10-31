> edit network config Router (Durin)
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
        address 10.66.1.1
        netmask 255.255.255.0

auto eth2
iface eth2 inet static
        address 10.66.2.1
        netmask 255.255.255.0

auto eth3
iface eth3 inet static
         address 10.66.3.1
         netmask 255.255.255.0

auto eth4
iface eth4 inet static
         address 10.66.4.1
         netmask 255.255.255.0

auto eth5
iface eth5 inet static
         address 10.66.5.1
         netmask 255.255.255.0

nano /etc/sysctl.conf
sysctl -w net.ipv4.ip_forward=1

apt update
apt install iptables -y
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 10.66.0.0/16

> Config Client

nano /root/.bashrc
echo nameserver 192.168.122.1 > /etc/resolv.conf

Switch 1

Elendil (Subnet 1)

auto eth0
iface eth0 inet static
    address 10.66.1.2
    netmask 255.255.255.0
    gateway 10.66.1.1


Isildur (Subnet 1)

auto eth0
iface eth0 inet static
    address 10.66.1.3
    netmask 255.255.255.0
    gateway 10.66.1.1


Anarion (Subnet 1)

auto eth0
iface eth0 inet static
    address 10.66.1.4
    netmask 255.255.255.0
    gateway 10.66.1.1

Switch 2

Gilgalad (Subnet 2)

auto eth0
iface eth0 inet static
    address 10.66.2.2
    netmask 255.255.255.0
    gateway 10.66.2.1


Celebrimbor (Subnet 2)

auto eth0
iface eth0 inet static
    address 10.66.2.3
    netmask 255.255.255.0
    gateway 10.66.2.1


Minastir (Subnet 5)

auto eth0
iface eth0 inet static
    address 10.66.5.2
    netmask 255.255.255.0
    gateway 10.66.5.1


Pharazon (Subnet 5)

auto eth0
iface eth0 inet static
    address 10.66.5.3
    netmask 255.255.255.0
    gateway 10.66.5.1

Switch 3

Erendis (Subnet 3)

auto eth0
iface eth0 inet static
    address 10.66.3.2
    netmask 255.255.255.0
    gateway 10.66.3.1

Switch 4

Aldarion (Subnet 4)

auto eth0
iface eth0 inet static
    address 10.66.4.2
    netmask 255.255.255.0
    gateway 10.66.4.1


Palantir (Subnet 4)

auto eth0
iface eth0 inet static
    address 10.66.4.3
    netmask 255.255.255.0
    gateway 10.66.4.1


Narvi (Subnet 4)

auto eth0
iface eth0 inet static
    address 10.66.4.4
    netmask 255.255.255.0
    gateway 10.66.4.1

Switch 5

Galadriel (Subnet 2)

auto eth0
iface eth0 inet static
    address 10.66.2.4
    netmask 255.255.255.0
    gateway 10.66.2.1


Celeborn (Subnet 2)

auto eth0
iface eth0 inet static
    address 10.66.2.5
    netmask 255.255.255.0
    gateway 10.66.2.1


Oropher (Subnet 2)

auto eth0
iface eth0 inet static
    address 10.66.2.6
    netmask 255.255.255.0
    gateway 10.66.2.1

Switch 6

Amdir (Subnet 4)

auto eth0
iface eth0 inet static
    address 10.66.3.3
    netmask 255.255.255.0
    gateway 10.66.3.1

Switch 8

Miriel (Subnet 1)

auto eth0
iface eth0 inet static
    address 10.66.1.4
    netmask 255.255.255.0
    gateway 10.66.1.1


Amandil (Subnet 1)

auto eth0
iface eth0 inet static
    address 10.66.1.5
    netmask 255.255.255.0
    gateway 10.66.1.1


Elros (Subnet 1)

auto eth0
iface eth0 inet static
    address 10.66.1.6
    netmask 255.255.255.0
    gateway 10.66.1.1


Khamul (Subnet 1)

auto eth0
iface eth0 inet static
    address 10.66.3.3 
    netmask 255.255.255.0
    gateway 10.66.3.1