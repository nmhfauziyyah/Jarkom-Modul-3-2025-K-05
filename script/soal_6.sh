# DHCP (Aldarion)

# Di Aldarion
nano /etc/dhcp/dhcpd.conf

# Opsi Global
option domain-name-servers 10.66.3.10, 10.66.4.13;
default-lease-time 600;
max-lease-time 3600;        # DIUBAH: Batas maksimal 1 jam
authoritative;
log-facility local7;

# Subnet 1: Keluarga Manusia (eth1 Durin)
subnet 10.66.1.0 netmask 255.255.255.0 {
    option routers 10.66.1.1;
    option broadcast-address 10.66.1.255;
    range 10.66.1.6 10.66.1.34;
    range 10.66.1.68 10.66.1.94;
    default-lease-time 1800;    # DITAMBAHKAN: Setengah jam
}

# Subnet 2: Keluarga Peri (eth2 Durin)
subnet 10.66.2.0 netmask 255.255.255.0 {
    option routers 10.66.2.1;
    option broadcast-address 10.66.2.255;
    range 10.66.2.35 10.66.2.67;
    range 10.66.2.96 10.66.2.121;
    default-lease-time 600;     # DITAMBAHKAN: Seperenam jam
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

# Verifikasi DHCP Lease
cat /var/lib/dhcp/dhcpd.leases