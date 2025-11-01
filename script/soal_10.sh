# Di Elros (Load Balancer - 10.66.1.6)
# === PERSIAPAN: Instal Nginx (WAJIB via Proxy Soal 3) ===

# 1. Konfigurasi proxy untuk APT
echo 'Acquire::http::Proxy "http://10.66.5.2:3128/";' > /etc/apt/apt.conf.d/01proxy

# 2. Paksa 'apt' pakai HTTP (karena proxy kita tidak bisa HTTPS)
sed -i 's/https/http/g' /etc/apt/sources.list

# 3. Hapus lock (jika ada sisa kegagalan)
rm -f /var/lib/apt/lists/lock
rm -f /var/lib/dpkg/lock

# 4. Instal Nginx
apt update
apt install -y nginx
ln -s /etc/init.d/named /etc/init.d/bind9 # (Symlink nginx, jika perlu)
ln -s /etc/init.d/nginx /etc/init.d/nginx # (Symlink nginx, jika perlu)

# === KONFIGURASI NGINX (Load Balancer) ===

cat > /etc/nginx/sites-available/elros << EOF
# Mendefinisikan grup server backend (para Ksatria Numenor)
# Nginx akan menggunakan Round Robin secara default
upstream kesatria_numenor {
    server 10.66.1.2:8001; # Elendil
    server 10.66.1.3:8002; # Isildur
    server 10.66.1.4:8003; # Anarion
}

server {
    listen 80;
    server_name elros.K05.com; # Domain Anda

    location / {
        # Meneruskan semua permintaan ke grup 'kesatria_numenor'
        proxy_pass http://kesatria_numenor;

        # Header tambahan untuk meneruskan info klien ke Laravel
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    # Log kustom untuk Elros
    access_log /var/log/nginx/elros_access.log;
    error_log /var/log/nginx/elros_error.log;
}
EOF


# Aktifkan situs load balancer
ln -s /etc/nginx/sites-available/elros /etc/nginx/sites-enabled/
# Hapus situs default agar tidak bentrok
rm /etc/nginx/sites-enabled/default

# Cek sintaks dan restart Nginx
nginx -t
service nginx restart

# Verifikasi (di Klien, misal Miriel)
# === PERSIAPAN (Pastikan DNS sudah benar) ===
# (Pastikan Miriel menunjuk ke Minastir (10.66.5.2) sesuai Soal 3/4)
cat << EOF > /etc/resolv.conf
search K05.com
nameserver 10.66.5.2
EOF

# === TES ===

# 1. Tes Halaman Utama (Lynx)
echo "--- Tes Halaman Utama (Lynx) ---"
lynx -dump http://elros.K05.com

# 2. Tes API (Curl)
# (Gunakan /api/airings sesuai Soal 9)
echo "--- Tes API (Curl) ---"
curl http://elros.K05.com/api/airings

# 3. Tes Round Robin (Sangat Penting)
# Kita akan mengambil ID unik dari 10 request
# Jika Round Robin bekerja, Anda akan melihat ID yang berbeda-beda
echo "--- Tes Distribusi Round Robin (memeriksa log worker) ---"
for i in {1..9}; do
    curl -s http://elros.K05.com > /dev/null
done

# 4. Buka terminal di Elros dan cek log-nya
# (ANDA HARUS MELAKUKAN INI DI ELROS)
echo "--- Pergi ke 'Elros' dan jalankan perintah log ini: ---"
echo "tail -n 9 /var/log/nginx/elros_access.log"

# 5. Buka terminal di Elendil, Isildur, dan Anarion
# (ANDA HARUS MELAKUKAN INI DI MASING-MASING WORKER)
echo "--- Pergi ke 'Elendil', 'Isildur', 'Anarion' dan jalankan: ---"
echo "tail -n 5 /var/log/nginx/access.log"