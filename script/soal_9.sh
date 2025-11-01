# 1. Tes Halaman Utama (Lynx)
echo "--- Tes Halaman Utama (Lynx) ---"
lynx -dump http://elendil.K05.com:8001
lynx -dump http://isildur.K05.com:8002
lynx -dump http://anarion.K05.com:8003

# 2. Tes API (Curl - pastikan data JSON kembali)
echo "--- Tes Koneksi API (Curl) ---"
curl http://elendil.K05.com:8001/api/airings
curl http://isildur.K05.com:8002/api/airings
curl http://anarion.K05.com:8003/api/airings

# 3. Tes Konsistensi Database (Diff)
#    Ini membuktikan semua worker terhubung ke Palantir yang SAMA.
echo "--- Tes Konsistensi Database (Diff) ---"
curl -s http://elendil.K05.com:8001/api/airings > /tmp/elendil.json
curl -s http://isildur.K05.com:8002/api/airings > /tmp/isildur.json
curl -s http://anarion.K05.com:8003/api/airings > /tmp/anarion.json

# Jalankan diff. Jika tidak ada output, berarti file identik (SUKSES)
diff /tmp/elendil.json /tmp/isildur.json
diff /tmp/isildur.json /tmp/anarion.json