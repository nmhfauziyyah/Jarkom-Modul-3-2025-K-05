# Di Palantir (Database Server - 10.66.4.3)
apt-get update
apt-get install -y mariadb-server mariadb-client

# 2. Mulai layanan dan tunggu sebentar
service mariadb start
sleep 5

# 3. Buat Database dan User
mysql -e "CREATE DATABASE IF NOT EXISTS laravel_db;"
mysql -e "CREATE USER IF NOT EXISTS 'laravel_user'@'%' IDENTIFIED BY 'password123';"
mysql -e "GRANT ALL PRIVILEGES ON laravel_db.* TO 'laravel_user'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# 4. Izinkan koneksi dari luar (selain localhost)
sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# 5. Restart MariaDB
service mariadb restart

# Di Elendil (Worker 1 - 10.66.1.2)
# 1. Masuk ke direktori Laravel
cd /var/www/laravel-simple-rest-api

# 2. Buat file .env (dengan DB_HOST yang benar)
cat > .env << EOF
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=10.66.4.3
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel_user
DB_PASSWORD=password123
EOF

# 3. Buat APP_KEY
php artisan key:generate

# 4. (HANYA DI ELENDIL) Jalankan Migrasi & Seeding
php artisan migrate:fresh --seed

# 5. Buat Konfigurasi Nginx
cat > /etc/nginx/sites-available/elendil << EOF
# Blokir akses IP (memenuhi Soal 8)
server {
    listen 8001 default_server;
    server_name _; # Menangkap semua host yang tidak cocok
    return 403; # Forbidden
}
server {
    listen 8001;
    server_name elendil.K05.com;

    root /var/www/laravel-simple-rest-api/public;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF

# 6. Aktifkan situs Elendil (dan hapus link lama/default)
ln -s /etc/nginx/sites-available/elendil /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# 7. Atur Izin & Bersihkan Cache
chown -R www-data:www-data /var/www/laravel-simple-rest-api
chmod -R 775 /var/www/laravel-simple-rest-api/storage
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

# 8. Restart layanan
nginx -t
service nginx restart
service php8.4-fpm restart

# Di Isildur (Worker 2 - 10.66.1.3)
# 1. Masuk ke direktori Laravel
cd /var/www/laravel-simple-rest-api

# 2. Buat file .env (dengan DB_HOST yang benar)
cat > .env << EOF
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=10.66.4.3
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel_user
DB_PASSWORD=password123
EOF

# 3. Buat APP_KEY
php artisan key:generate

# 4. (HANYA DI ISILDUR) Jalankan Migrasi & Seeding
php artisan migrate:fresh --seed

# 5. Buat Konfigurasi Nginx
cat > /etc/nginx/sites-available/isildur << EOF
# Blokir akses IP (memenuhi Soal 8)
server {
    listen 8002 default_server;
    server_name _; # Menangkap semua host yang tidak cocok
    return 403; # Forbidden
}
server {
    listen 8002;
    server_name isildur.K05.com;

    root /var/www/laravel-simple-rest-api/public;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF

# 6. Aktifkan situs Isildur (dan hapus link lama/default)
ln -s /etc/nginx/sites-available/isildur /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# 7. Atur Izin & Bersihkan Cache
chown -R www-data:www-data /var/www/laravel-simple-rest-api
chmod -R 775 /var/www/laravel-simple-rest-api/storage
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

# 8. Restart layanan
nginx -t
service nginx restart
service php8.4-fpm restart

# Di Anarion (Worker 3 - 10.66.1.4)
# 1. Masuk ke direktori Laravel
cd /var/www/laravel-simple-rest-api

# 2. Buat file .env
cat > .env << EOF
APP_NAME=Laravel
APP_ENV=local
APP_KEY=
APP_DEBUG=true
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=10.66.4.3
DB_PORT=3306
DB_DATABASE=laravel_db
DB_USERNAME=laravel_user
DB_PASSWORD=password123
EOF

# 3. Buat APP_KEY
php artisan key:generate

# 4. Buat Konfigurasi Nginx
cat > /etc/nginx/sites-available/anarion << EOF
# Blokir akses IP
server {
    listen 8003 default_server;
    server_name _; # Menangkap semua host yang tidak cocok
    return 403; # Forbidden
}
server {
    listen 8003;
    server_name anarion.K05.com;

    root /var/www/laravel-simple-rest-api/public;
    index index.php;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.4-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$realpath_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOF

# 5. Aktifkan situs Anarion (dan hapus link lama/default)
ln -s /etc/nginx/sites-available/anarion /etc/nginx/sites-enabled/
rm /etc/nginx/sites-enabled/default

# 6. Atur Izin & Bersihkan Cache
chown -R www-data:www-data /var/www/laravel-simple-rest-api
chmod -R 775 /var/www/laravel-simple-rest-api/storage
php artisan config:clear
php artisan cache:clear
php artisan route:clear
php artisan view:clear

# 7. Restart layanan
nginx -t
service nginx restart
service php8.4-fpm restart

# Node Palantir (10.66.4.3)
Bash

service mariadb status
mysql -e "SHOW DATABASES;"
mysql -e "SELECT user, host FROM mysql.user WHERE user='laravel_user';"
cat /etc/mysql/mariadb.conf.d/50-server.cnf | grep bind-address
netstat -tulpn | grep 3306
mysql -u laravel_user -ppassword123 -e "USE laravel_db; SHOW TABLES;"

# Node Elendil (10.66.1.2)
cd /var/www/laravel-simple-rest-api
# (Perintah 'php artisan migrate' hanya dijalankan sekali saat setup)

# Tes koneksi ke DB Palantir
mysql -h 10.66.4.3 -u laravel_user -ppassword123 -e "USE laravel_db; SHOW TABLES;"

# Tes apakah seeding berhasil
mysql -h 10.66.4.3 -u laravel_user -ppassword123 -e "USE laravel_db; SELECT COUNT(*) FROM airings;"
mysql -h 10.66.4.3 -u laravel_user -ppassword123 -e "USE laravel_db; SELECT COUNT(*) FROM users;"

# Cek Nginx
nginx -t
netstat -tulpn | grep 8001

# Tes akses via IP (Harus Gagal - 403)
curl -o /dev/null -s -w "%{http_code}\n" http://10.66.1.2:8001

# Node Isildur (10.66.1.3)
netstat -tulpn | grep 8002

# Tes akses via IP (Harus Gagal - 403)
curl -o /dev/null -s -w "%{http_code}\n" http://10.66.1.3:8002

# Node Anarion (10.66.1.4)
netstat -tulpn | grep 8003

# Tes akses via IP (Harus Gagal - 403)
curl -o /dev/null -s -w "%{http_code}\n" http://10.66.1.4:8003

# Node Client (misal: Miriel)
# Tes akses via IP (HarGus Gagal - 403)
curl -I http://10.66.1.2:8001

# Tes akses via Domain (Harus Berhasil - 200 OK)
curl -I http://elendil.K05.com:8001

# Tes akses API (Harus mengembalikan data JSON)
lynx http://elendil.K05.com:8001/api/airings
