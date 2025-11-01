# Soal 7: Instalasi Laravel Worker (Elendil, Isildur, Anarion)
# File: /root/.bashrc
#!/bin/bash

# ===============================================
# FASE 1: KONFIGURASI DNS (Memastikan Akses Internet)
# ===============================================

# Menggunakan DNS lokal (Erendis & Amdir) dan DNS Forwarder (Minastir) 
# sebagai solusi tercepat dan paling andal untuk akses internet.
cat << EOF > /etc/resolv.conf
nameserver 10.66.3.2  # Erendis (Master DNS Lokal)
nameserver 10.66.3.3  # Amdir (Slave DNS Lokal)
nameserver 10.66.5.2  # Minastir (DNS Forwarder Internet)
EOF

# ===============================================
# FASE 2: INSTALASI TOOLS LARAVEL (Soal 7)
# ===============================================

# 3. Instalasi Repository PHP
# Update APT untuk memastikan daftar paket terbaru
apt update

# Instalasi paket kunci yang mungkin belum terinstal (dijaga jika ada host lain)
apt install -y lsb-release ca-certificates apt-transport-https gnupg2 git wget unzip

# Ambil GPG key untuk repository PHP Sury
curl -sSLo /usr/share/keyrings/deb.sury.org-php.gpg https://packages.sury.org/php/apt.gpg

# Tambahkan repository PHP Sury (lsb_release -sc sekarang pasti berfungsi)
echo "deb [signed-by=/usr/share/keyrings/deb.sury.org-php.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

# Update APT untuk memuat repository PHP yang baru ditambahkan
apt update

# 4. Instalasi PHP 8.4 dan Ekstensi Wajib
apt-get install -y php8.4-mbstring php8.4-xml php8.4-cli php8.4-common php8.4-intl php8.4-opcache php8.4-readline php8.4-mysql php8.4-fpm php8.4-curl

# 5. Instalasi Nginx, MariaDB Client, dan Tools Monitoring/Client
apt-get install -y nginx mariadb-client dnsutils lynx htop

# 6. Instalasi Composer 2 (Sekarang seharusnya berhasil didownload melalui HTTPS)
wget https://getcomposer.org/download/2.0.13/composer.phar
chmod +x composer.phar
mv composer.phar /usr/bin/composer

---

# 7. Instalasi Laravel Simple REST API
cd /var/www
git clone https://github.com/elshiraphine/laravel-simple-rest-api /var/www/laravel-simple-rest-api
cd laravel-simple-rest-api
composer update --no-dev

cp .env.example .env

# Debugging klo error instalasi :
rm /etc/apt/sources.list.d/php.list

