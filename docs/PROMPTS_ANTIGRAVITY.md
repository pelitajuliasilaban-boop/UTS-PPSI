# Prompt untuk Antigravity (urut per fase)

Cara pakai: buka folder proyek ini di Antigravity, buka Agent Manager atau panel agent, lalu kirim prompt satu per satu. Tunggu tiap fase selesai dan dites sebelum lanjut. Untuk fase tampilan, desain Stitch sudah ada di folder `design/` (tidak perlu lampiran).

## Fase 0: Pemahaman proyek
```
Baca AGENTS.md, docs/PRD.md, dan migrations/0001_init.sql. Ringkas dalam 10 poin apa yang akan dibangun, urutan pengerjaan yang kamu usulkan, dan daftar Open Question yang paling mempengaruhi implementasi. Jangan menulis kode dulu.
```

## Fase 1: Fondasi (database, konfigurasi, autentikasi)
```
Kerjakan fondasi backend sesuai PRD F1. Tambahkan dependensi yang perlu (sqlx postgres, argon2, serde, tracing, uuid, chrono atau time, tower-http). Buat: koneksi PostgreSQL dari DATABASE_URL, runner migrasi, registrasi dan login email+kata sandi (argon2), sesi berbasis token dengan masa berlaku, logout, middleware RBAC untuk 6 peran (wisatawan, petugas, pengelola, mitra, admin, pembaca), rate limit login. Tambahkan seed: satu akun per peran dan 3 destinasi contoh yang diberi label "data contoh". Tulis test untuk login dan RBAC. Jalankan cargo check dan cargo test.
```

## Fase 2: Katalog dan admin
```
Kerjakan PRD F2 dan F10. API publik katalog destinasi bilingual (ID/EN), detail destinasi, tarif aktif, sisa kuota per tanggal. API admin: CRUD destinasi, tarif, kuota harian, paket wisata (F4 bagian admin). Perubahan tarif hanya berlaku untuk pesanan baru. Catat setiap perubahan tarif/kuota/peran ke audit_logs. Tambahkan test.
```

## Fase 3: Pembelian tiket, kuota, pembayaran sandbox
```
Kerjakan PRD F3, F4, F5. Alur: buat pesanan (tiket tunggal atau paket) -> status menunggu_bayar dengan expires_at -> kuota ditahan memakai SELECT ... FOR UPDATE dalam transaksi -> pembayaran sandbox (halaman simulasi hanya aktif jika PAYMENT_MODE=sandbox) -> webhook idempoten dengan verifikasi tanda tangan HMAC -> pesanan lunas. Pesanan yang kedaluwarsa melepas kuota (job periodik atau pengecekan saat akses). Abstraksikan provider pembayaran lewat trait agar gateway asli bisa dipasang nanti. Tulis test: dua pembeli serentak untuk kuota terakhir (hanya satu berhasil), webhook dikirim dua kali (satu pembayaran, satu set tiket).
```

## Fase 4: Tiket QR dan scan gerbang
```
Kerjakan PRD F6 dan F7 sisi backend. Setelah pesanan lunas, terbitkan satu tiket per item (per destinasi untuk paket) dengan kode unik dan token HMAC-SHA256 (QR_HMAC_SECRET). Endpoint validasi scan oleh petugas: valid, sudah dipakai, kedaluwarsa, salah destinasi, tidak dikenal; pemakaian atomik lewat UPDATE ... WHERE status='aktif' ... RETURNING. Catat semua scan ke tabel scans. Endpoint sinkronisasi batch untuk scan offline dengan aturan scan tertua menang dan konflik dicatat. Tulis test: scan ganda dan serentak, QR palsu, salah tanggal/destinasi.
```

## Fase 5: Dashboard
```
Kerjakan PRD F8. Endpoint agregat: tiket terjual, pengunjung terpindai, pendapatan per destinasi untuk hari ini, 7 hari, 30 hari (zona waktu Asia/Jakarta). Tampilkan terjual dan terpindai terpisah (OQ-13). Peran pembaca hanya read-only; pengelola hanya melihat destinasinya. Frontend memakai polling tiap 30-60 detik. Tambahkan index yang perlu dan test RBAC.
```

## Fase 6: Mitra homestay dan pemandu
```
Kerjakan PRD F9. Registrasi mitra, verifikasi oleh admin (menunggu/disetujui/ditolak), pengelolaan layanan dan ketersediaan tanggal, pemesanan oleh wisatawan, terima/tolak oleh mitra dengan batas waktu respons, status kedaluwarsa otomatis. Hanya mitra disetujui yang tampil di katalog. Pembayaran booking mitra masih Open Question (OQ-14): implementasikan tanpa komisi dan tandai // OQ-14.
```

## Fase 7: Frontend sesuai desain Stitch
```
Bangun frontend untuk semua peran berdasarkan desain di folder design/ (baca design/README.md, lalu buka tiap file HTML), memakai HTML/CSS/JavaScript di folder public/. Pertahankan palet dan gaya dari desain, tapi jangan salin Tailwind CDN: pindahkan token ke public/style.css. Layar yang belum ada desainnya (beranda wisatawan, detail, checkout, tiket QR) dibuat dengan gaya yang sama. Terapkan: dua bahasa ID/EN dengan tombol pengalih, halaman wisatawan (beranda, detail, checkout, tiket QR, homestay), halaman scanner petugas dengan kamera, dashboard admin dan pembaca, panel mitra dan pengelola. Footer wajib sesuai AGENTS.md ada di setiap halaman. Hubungkan ke API yang sudah dibuat.
```

## Fase 8: PWA dan mode offline
```
Kerjakan PRD F11 dan FR-7.3. Tambahkan manifest dan service worker: cache aset (termasuk logo footer), tiket QR bisa dibuka offline, scanner menyimpan daftar tiket valid hari itu dan antrean scan di penyimpanan lokal lalu menyinkronkan saat online. Tampilkan status Online/Offline dan jumlah scan tertunda. Tiket yang tidak ada di cache saat offline: tampilkan "tidak dapat diverifikasi offline" (OQ-11).
```

## Fase 9: Rapikan dan siap uji
```
Jalankan cargo check, cargo clippy, dan cargo test. Perbaiki semua kegagalan. Buat docs/TESTING.md berisi cara menjalankan aplikasi dan semua test. Pastikan footer ada di semua halaman. Lalu daftarkan semua penanda // OQ-n yang tersisa di kode beserta lokasinya.
```
