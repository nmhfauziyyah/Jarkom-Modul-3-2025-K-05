# CNAME, TXT record, dan Reverse DNS (PTR).

--- Erendis
# 1. (Erendis) Tambahkan definisi Reverse Zone ke named.conf.local
# Kita gunakan '>>' untuk MENAMBAHKAN di akhir file, bukan menimpanya.
nano /etc/bind/named.conf.local

zone "K05.com" {
    type master;
    notify yes;
    also-notify { 10.66.3.3; };
    allow-transfer { 10.66.3.3; };
    file "/etc/bind/K05/db.K05.com";
};

#tambahkan baris berikut di akhir file:
# Reverse zone untuk jaringan 10.66.3.0/24
zone "3.66.2.in-addr.arpa" {
    type master;
    notify yes;
    also-notify { 10.66.3.3; };
    allow-transfer { 10.66.3.3; };
    file "/etc/bind/K05/db.10.66.3";
};

# 2. (Erendis) Buat file Reverse Zone untuk PTR records
nano /etc/bind/K05/db.10.66.3
$TTL 604800
@       IN      SOA     ns1.K05.com. admin.K05.com. (
                        2025103001      ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
; Name Servers
@       IN      NS      ns1.K05.com.
@       IN      NS      ns2.K05.com.
;
; PTR Records
10      IN      PTR     ns1.K05.com.    ; 10.66.3.2 -> ns1.K05.com
11      IN      PTR     ns2.K05.com.    ; 10.66.3.3 -> ns2.K05.com

# 4. Restart dan Konfigurasi Final Nameserver
service bind9 restart

--- Amdir
# 1. (Amdir) Tambahkan definisi Reverse Zone ke named.conf.local
nano /etc/bind/named.conf.local
#tambahkan baris berikut di akhir file:
zone "3.66.2.in-addr.arpa" {
    type slave;
    masters { 10.66.3.2; };
    file "/var/cache/bind/db.10.66.2";
};

# 2. Restart BIND9 di Amdir
service bind9 restart

--
# 3. Cek apakah zone sudah tersinkronisasi
dig -t CNAME www.K05.com
dig TXT K05.com
dig 10.66.3.2
dig 10.66.3.3