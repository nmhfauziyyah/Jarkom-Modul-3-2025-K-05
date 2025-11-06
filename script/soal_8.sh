PALANTIR
# 1. Update dan install MariaDB Server
apt-get update
apt-get install -y mariadb-server

# 2. Mulai layanan
service mariadb start

# 3. Buat Database dan User (Menggunakan -e agar tidak perlu masuk ke shell)
# (Menggunakan kredensial dari skrip pertama Anda)
mysql -e "CREATE DATABASE IF NOT EXISTS dbkelompokK05;"
mysql -e "CREATE USER IF NOT EXISTS 'kelompokK05'@'%' IDENTIFIED BY 'passwordK05';"
mysql -e "GRANT ALL PRIVILEGES ON dbkelompokK05.* TO 'kelompokK05'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# 4. Izinkan koneksi dari luar (selain localhost)
# Ini adalah cara yang benar untuk mengedit file konfigurasi agar bind-address = 0.0.0.0
sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# 5. Restart MariaDB agar konfigurasi baru terbaca
service mariadb restart

# 6. Verifikasi bahwa MariaDB berjalan di port 3306 untuk semua IP (0.0.0.0)
netstat -tulpn | grep 3306

---
Worker
# 1. Masuk ke direktori aplikasi
cd /var/www/laravel-simple-rest-api

# 2. Buat file .env dengan koneksi ke Palantir
# Pastikan DB_HOST mengarah ke IP Palantir (10.66.4.3)
cat > .env << EOF
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=10.66.4.3
DB_PORT=3306
DB_DATABASE=dbkelompokK05
DB_USERNAME=kelompokK05
DB_PASSWORD=passwordK05
EOF

# 3. Buat Application Key
php artisan key:generate

# 4. Atur Izin folder agar Nginx dan PHP bisa menulis
chown -R www-data:www-data /var/www/laravel-simple-rest-api
chmod -R 775 /var/www/laravel-simple-rest-api/storage

# 5. Bersihkan cache konfigurasi (karena .env baru dibuat)
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

-- ELENDIR
# 1. Masuk ke direktori aplikasi
cd /var/www/laravel-simple-rest-api

# 2. (HANYA DI ELENDIL) Jalankan Migrasi & Seeding
# Perintah ini akan membuat tabel dan mengisi data awal dari Palantir
php artisan migrate:fresh --seed

# 3. Buat Konfigurasi Nginx untuk Elendil (Port 8001)
rm -f /etc/nginx/sites-enabled/default

cat << 'EOF' > /etc/nginx/sites-available/elendil
server {
    listen 8001;
    server_name elendil.K05.com;

    # Aturan agar akses web HANYA bisa melalui domain (Soal 8)
    # Jika host tidak sama dengan domain, tutup koneksi (444)
    if ($host != "elendil.K05.com") {
        return 444; 
    }

    root /var/www/laravel-simple-rest-api/public;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock; # Sesuaikan versi PHP
    }
}
EOF

# 4. Aktifkan situs Elendil
ln -s /etc/nginx/sites-available/elendil /etc/nginx/sites-enabled/

# 5. Tes konfigurasi Nginx dan restart layanan
nginx -t
service nginx restart
service php8.4-fpm restart

-- ISILDUR
# 1. Buat Konfigurasi Nginx untuk Isildur (Port 8002)
rm -f /etc/nginx/sites-enabled/default

cat << 'EOF' > /etc/nginx/sites-available/isildur
server {
    listen 8002;
    server_name isildur.K05.com;

    # Aturan agar akses web HANYA bisa melalui domain (Soal 8)
    if ($host != "isildur.K05.com") {
        return 444;
    }

    root /var/www/laravel-simple-rest-api/public;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock; # Sesuaikan versi PHP
    }
}
EOF

# 2. Aktifkan situs Isildur
ln -s /etc/nginx/sites-available/isildur /etc/nginx/sites-enabled/

# 3. Tes konfigurasi Nginx dan restart layanan
nginx -t
service nginx restart
service php8.4-fpm restart

-- ANARION
# 1. Buat Konfigurasi Nginx untuk Anarion (Port 8003)
rm -f /etc/nginx/sites-enabled/default

cat << 'EOF' > /etc/nginx/sites-available/anarion
server {
    listen 8003;
    server_name anarion.K05.com;

    # Aturan agar akses web HANYA bisa melalui domain (Soal 8)
    if ($host != "anarion.K05.com") {
        return 444;
    }

    root /var/www/laravel-simple-rest-api/public;
    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock; # Sesuaikan versi PHP
    }
}
EOF

# 2. Aktifkan situs Anarion
ln -s /etc/nginx/sites-available/anarion /etc/nginx/sites-enabled/

# 3. Tes konfigurasi Nginx dan restart layanan
nginx -t
service nginx restart
service php8.4-fpm restart
