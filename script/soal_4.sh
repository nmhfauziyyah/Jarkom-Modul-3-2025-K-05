# Di Erendis (IP Static: 10.66.3.10)

# 1. Nameserver Awal (Untuk akses Internet/apt update)
cat << EOF > /etc/resolv.conf
Search K05.com
nameserver 10.66.3.2
nameserver 10.66.3.3
nameserver 10.66.5.2
EOF

# 3. Instalasi Tools (BIND9 dan Tools Pengujian)
apt update
apt install bind9 dnsutils lynx nginx php8.4-fpm php-mysql htop -y
ln -s /etc/init.d/named /etc/init.d/bind9
mkdir -p /etc/bind/K05

# Erendis/Amdir: Isi /etc/bind/named.conf.options (REVISI)

options {
    directory "/var/cache/bind";

    # Izinkan query dari semua subnet internal
    allow-query { 10.66.0.0/16; }; 

    # Teruskan kueri NON-lokal ke Minastir
    forwarders {
        10.66.5.2; # <--- WAJIB: Gunakan titik koma (;)
    };
    
    # JANGAN gunakan forward only;
    
    dnssec-validation auto;
    listen-on-v6 { any; };
};

# 5. Konfigurasi Zones (named.conf.local)
cat << EOF > /etc/bind/named.conf.local
zone "K05.com" {
    type master;
    notify yes;
    also-notify { 10.66.3.3; };
    allow-transfer { 10.66.3.3; };
    file "/etc/bind/K05/db.K05.com";
};
EOF

--- Erendis
# 6. Konfigurasi Forward Zone File (db.K05.com)
nano /etc/bind/K05/db.K05.com
$TTL 604800
@       IN      SOA     ns1.K05.com. admin.K05.com. (
                2025103001 ; Serial
                604800     ; Refresh
                86400      ; Retry
                2419200    ; Expire
                604800 )   ; Negative Cache TTL

@               IN      NS      ns1.K05.com.
@               IN      NS      ns2.K05.com.
@               IN      A       10.66.3.2  ; Default/Apex

ns1             IN      A       10.66.3.2  ;  ns1.K05.com -> Erendis (Master)
ns2             IN      A       10.66.3.3  ;  ns2.K05.com -> Amdir (Slave)

; --- A Records untuk Lokasi Penting (Soal 4) ---
palantir        IN      A       10.66.4.3
elros           IN      A       10.66.1.6
pharazon        IN      A       10.66.2.6
elendil         IN      A       10.66.1.2
isildur         IN      A       10.66.1.3
anarion         IN      A       10.66.1.4
galadriel       IN      A       10.66.2.2
celeborn        IN      A       10.66.2.3
oropher         IN      A       10.66.2.4

; --- ALIAS DAN PESAN RAHASIA (Soal 5) ---
www         IN      CNAME   K05.com.    ; Alias www -> @ (Apex)

; Pesan Rahasia (TXT Record)
@           IN      TXT     "Cincin Sauron=elros.K05.com."
@           IN      TXT     "Aliansi Terakhir=pharazon.K05.com."


# 7. Restart dan Konfigurasi Final Nameserver
service bind9 restart
-----------------------------------------------------

--- Amdir
# Di Amdir (IP Static: 10.66.3.11)
# 1. Nameserver Awal (Untuk akses Internet/apt update)
cat << EOF > /etc/resolv.conf
Search K05.com
nameserver 10.66.3.2
nameserver 10.66.3.3
nameserver 10.66.5.2
nameserver 192.168.122.1
EOF

# 3. Instalasi BIND9 & Tools
apt update
apt install bind9 dnsutils lynx htop -y
ln -s /etc/init.d/named /etc/init.d/bind9

# Erendis/Amdir: Isi /etc/bind/named.conf.options (REVISI)

options {
    directory "/var/cache/bind";

    # Izinkan query dari semua subnet internal
    allow-query { 10.66.0.0/16; }; 

    # Teruskan kueri NON-lokal ke Minastir
    forwarders {
        10.66.5.2; # <--- WAJIB: Gunakan titik koma (;)
    };
    
    # JANGAN gunakan forward only;
    
    dnssec-validation auto;
    listen-on-v6 { any; };
};

# 5. Konfigurasi Zones sebagai Slave
## Deklarasi Zona Slave ;
cat << EOF > /etc/bind/named.conf.local
zone "K05.com" {
    type slave;
    masters { 10.66.3.2; };
    file "/var/cache/bind/db.K05.com";
};
EOF

# 6. Restart dan Nameserver Final
service bind9 restart

--
