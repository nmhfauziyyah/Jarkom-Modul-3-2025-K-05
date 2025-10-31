> Aldarion (DHCP server)
# tambahkan di nano /root/.bashrc
apt update
apt install isc-dhcp-server
dhcpd --version

cat <<EOF > /etc/default/isc-dhcp-server
INTERFACESv4="eth0"
INTERFACESv6=""
EOF

nano /etc/dhcp/dhcpd.conf
# Opsi Global
option domain-name-servers 10.66.3.10, 10.66.4.13;
default-lease-time 600;
max-lease-time 7200;
authoritative;
log-facility local7;

# Subnet 1: Keluarga Manusia (eth1 Durin)
subnet 10.66.1.0 netmask 255.255.255.0 {
    option routers 10.66.1.1;
    option broadcast-address 10.66.1.255;
    range 10.66.1.6 10.66.1.34;
    range 10.66.1.68 10.66.1.94;
}

# Subnet 2: Keluarga Peri (eth2 Durin)
subnet 10.66.2.0 netmask 255.255.255.0 {
    option routers 10.66.2.1;
    option broadcast-address 10.66.2.255;
    range 10.66.2.35 10.66.2.67;
    range 10.66.2.96 10.66.2.121;
}

# Subnet 3: Wilayah Khamul (eth3 Durin)
subnet 10.66.3.0 netmask 255.255.255.0 {
    option routers 10.66.3.1;
    option broadcast-address 10.66.3.255;
}

# Subnet 4: Jangkar untuk Aldarion (Server DHCP)
subnet 10.66.4.0 netmask 255.255.255.0 {
    option routers 10.66.4.1;
    option broadcast-address 10.66.4.255;
}

# Alamat Tetap untuk Khamul
host khamul {
    hardware ethernet 02:42:c4:30:99:00;
    fixed-address 10.66.3.95;
}

service isc-dhcp-server restart

> Durin 
# nano /root/.bashrc
apt update
apt install isc-dhcp-relay

# nano /etc/default/isc-dhcp-relay
# IP Aldarion (si DHCP Server)
SERVERS="10.66.4.10"

# Interface di Durin yang "mendengarkan" permintaan DHCP dari klien
# eth1 -> Amandil (Manusia)
# eth2 -> Gilgalad (Peri)
# eth3 -> Khamul (Misterius)
INTERFACES="eth4 eth1 eth2 eth3"

service isc-dhcp-relay restart


> Khamul
nano /etc/network/interfaces
# tambahkan
hwaddress ether 02:42:c4:30:99:00

------
#!/bin/bash

# in Aldarion (DHCP Server)
# Aldarion (DHCP Server)
nano /root/.bashrc
apt-get update
apt-get install -y isc-dhcp-server

# Memberi tahu isc-dhcp-server agar "mendengarkan" di eth0
cat <<EOF > /etc/default/isc-dhcp-server
INTERFACESv4="eth0"
INTERFACESv6=""
EOF

# Konfigurasi Utama DHCP
cat <<EOF > /etc/dhcp/dhcpd.conf

ddns-update-style none;
authoritative;
log-facility local7;

default-lease-time 600;
max-lease-time 7200;

# Manusia (Amandil) ---
subnet 10.66.1.0 netmask 255.255.255.0 {
    range 10.66.1.6 10.66.1.34; # ke dobel sama ip-nya elros(1.6)
    range 10.66.1.68 10.66.1.94;
    option routers 10.66.1.1;
    option broadcast-address 10.66.1.255;
    option domain-name-servers 10.66.3.2, 10.66.3.3, 192.168.122.1;
}

# Peri (Gilgalad) ---
subnet 10.66.2.0 netmask 255.255.255.0 {
    range 10.66.2.35 10.66.2.67;
    range 10.66.2.96 10.66.2.121;
    option routers 10.66.2.1;
    option broadcast-address 10.66.2.255;
    option domain-name-servers 10.66.3.2, 10.66.3.3, 192.168.122.1;
}

#  khamul
subnet 10.66.3.0 netmask 255.255.255.0 {
    option routers 10.66.3.1;
    option broadcast-address 10.66.3.255;
}

#DATABASE
subnet 10.66.4.0 netmask 255.255.255.0 {
    option routers 10.66.4.1;
    option broadcast-address 10.66.4.255;
}

#PROXY
subnet 10.66.5.0 netmask 255.255.255.0 {
    option routers 10.66.5.1;
    option broadcast-address 10.66.5.255;
}

# Aldarion 
# Wajib ada agar servis bisa menyala
subnet 10.66.4.0 netmask 255.255.255.0 {
}

host Khamul {
    hardware ethernet 02:42:c4:30:99:00;
    fixed-address 10.66.3.95;
}
EOF


service isc-dhcp-server restart

# in Durin (DHCP Relay)
cat <<EOF > /root/.bashrc
apt-get update
apt-get install -y isc-dhcp-relay
EOF

cat <<EOF > /etc/default/isc-dhcp-relay
# Defaults for isc-dhcp-relay (Durin)

# Arahkan ke IP baru Aldarion di Subnet 4
SERVERS="10.66.4.2"
INTERFACES="eth1 eth2 eth3 eth4 eth5"
EOF

# Konfigurasi IP Forwarding (mengaktifkan IP Forwarding)
cat <<EOF > /etc/sysctl.conf
net.ipv4.ip_forward=1
EOF

sysctl -p
service isc-dhcp-relay restart

# Jalankan ip a di setiap client:
# Amandil harus mendapatkan IP di rentang 10.66.1.6 - .34 atau 10.66.1.68 - .94.
# Gilgalad harus mendapatkan IP di rentang 10.66.2.35 - .67 atau 10.66.2.96 - .121.
# Khamul harus mendapatkan IP tepat 10.66.3.95.


