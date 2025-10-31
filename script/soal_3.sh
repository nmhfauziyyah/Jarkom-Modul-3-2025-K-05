# --- Skrip BARU Soal 3 untuk MINASTIR (DNS Forwarder) ---
# 192.216.5.2 (minastir)
echo "Menginstal BIND9..."
apt-get update
apt-get install -y bind9
ln -s /etc/init.d/named /etc/init.d/bind9

# 4. Konfigurasi Forwarder di Minastir
cat <<EOF > /etc/bind/named.conf.options
options {
    directory "/var/cache/bind";

    # Izinkan query dari semua subnet internal kita
    # Menggunakan notasi CIDR lengkap: IP_NETWORK/PREFIX
    allow-query { 10.66.0.0/16; }; # <--- Diperbaiki dari 10.66.0/16

    # Teruskan SEMUA query ke DNS Internet (misal: NAT GNS3)
    forwarders {
        10.66.5.2; # <--- WAJIB: Tambahkan titik koma (;)
    };
    forward only; # Ini menjadikannya murni forwarder

    dnssec-validation auto;
    listen-on-v6 { any; };
};
EOF

# PERBAIKAN: Buat file local kosong (agar named.conf tidak error)
touch /etc/bind/named.conf.local
service bind9 restart


# Cek di Gilgalad
dig google.com
dig elros.K05.com