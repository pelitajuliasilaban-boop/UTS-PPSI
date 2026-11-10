# PRD: Taput Wisata Pass

Platform tiket digital QR lintas destinasi wisata Kabupaten Tapanuli Utara

Penulis: Pelita Julia Silaban (NPM 24311046) · Pembimbing: Dr. Erliyan Redy Susanto, M.Kom · Status: Draf 1 · Stack: Rust + PostgreSQL, deploy Vercel

**Catatan interpretasi:** semua jawaban klarifikasi adalah "semuanya". Ini dibaca sebagai: semua peran, semua fitur utama, pembayaran sandbox dan gateway, semua opsi teknis, dan semua kriteria selesai masuk lingkup MVP. Konsekuensinya ada di bagian Goals dan Open Questions. Hal yang tidak bisa ditentukan dari jawaban tersebut ditandai **[OQ-n]**.

## 1. Problem Statement

**Siapa yang dirugikan**

- **Pemerintah daerah (Dinas Pariwisata, Bapenda/BPKAD):** retribusi tiket yang dibayar tunai di gerbang sulit diaudit. Jumlah pengunjung yang tercatat bergantung pada pencatatan manual petugas, sehingga data PAD dari pariwisata tidak akurat dan terlambat.
- **Wisatawan:** harus membeli tiket di tiap destinasi secara terpisah, tidak ada satu tempat untuk melihat destinasi, tarif, dan paket, serta antre di gerbang.
- **Petugas gerbang dan pengelola destinasi:** pencatatan manual rentan salah, tiket kertas bisa digandakan, dan laporan harus direkap tangan.
- **Pemilik homestay, pemandu lokal, UMKM:** tidak punya kanal promosi dan pemesanan terpadu yang terhubung dengan arus wisatawan.

**Mengapa terjadi:** tiket dan retribusi masih manual, tidak ada sistem terpusat lintas destinasi, dan tidak ada data pengunjung real-time.

**Konsekuensi:** potensi kebocoran retribusi, keputusan kebijakan tanpa data, dan peluang ekonomi lokal yang tidak terhubung.

*Catatan:* besaran kebocoran retribusi saat ini belum diketahui. Angka baseline harus dikumpulkan dari Dinas Pariwisata **[OQ-1]**.

## 2. Target User dan Persona

**Peran pengguna (semua masuk MVP)**

1. Wisatawan (publik)
2. Petugas gerbang destinasi
3. Pengelola destinasi
4. Mitra: pemilik homestay dan pemandu lokal
5. Admin Dinas Pariwisata
6. Pembaca dashboard: Bapenda/BPKAD dan pimpinan daerah (read-only)

### Persona 1: Wisatawan, "Rina"

- Usia 25-40, wisatawan domestik dari luar Tapanuli Utara, memakai ponsel Android dan membayar dengan QRIS.
- Tujuan: melihat destinasi, membeli satu tiket atau paket untuk beberapa destinasi, masuk tanpa antre.
- Hambatan: sinyal tidak stabil di lokasi wisata, tidak tahu tarif resmi, takut tiket palsu.

### Persona 2: Admin Dinas Pariwisata, "Pak Samuel"

- Pegawai dinas, memakai laptop, terbiasa dengan rekap Excel.
- Tujuan: memantau jumlah pengunjung dan pendapatan tiap destinasi hari ini, mengatur tarif dan paket, menarik laporan bulanan untuk Bapenda.
- Hambatan: data tersebar, laporan manual, tidak mau sistem rumit.

*Catatan:* kedua persona adalah asumsi perancangan. Perlu divalidasi lewat wawancara dengan pihak dinas **[OQ-2]**.

## 3. Goals dan Non-Goals

### Goals

- G1. Seluruh penjualan tiket destinasi yang terdaftar tercatat digital dan tidak bisa dipakai dua kali.
- G2. Wisatawan bisa membeli tiket tunggal atau paket lintas destinasi dalam satu alur.
- G3. Petugas bisa memvalidasi tiket di gerbang, termasuk saat tidak ada sinyal.
- G4. Admin dan pembaca dashboard melihat jumlah pengunjung dan pendapatan per destinasi hampir real-time.
- G5. Mitra homestay dan pemandu bisa terdaftar, dipesan, dan melihat pesanannya.
- G6. Seluruh antarmuka tersedia dalam dua bahasa (Indonesia dan Inggris) dan dapat dipasang sebagai PWA.
- G7. Sistem dibangun dengan Rust dan PostgreSQL, berjalan di Vercel, serta memuat footer wajib (logo Pemda, logo Universitas Teknokrat Indonesia, teks hak cipta).

### Non-Goals

- Tidak menggantikan sistem keuangan daerah resmi (SIPD/BUD). Sistem hanya menghasilkan laporan penerimaan.
- Tidak menyimpan data kartu atau rekening. Pembayaran sepenuhnya lewat gateway.
- Tidak menyediakan aplikasi native Android/iOS. Yang disediakan web responsif dan PWA.
- Tidak mencakup pemesanan transportasi, tiket pesawat, atau hotel di luar mitra homestay lokal.
- Tidak mencakup integrasi dengan sistem pemerintah pusat di MVP.

**Peringatan risiko lingkup:** jawaban "semuanya" membuat MVP sangat besar untuk satu mahasiswa dalam satu periode UTS. Urutan pengerjaan dan potongan yang boleh turun ke v2 harus diputuskan **[OQ-3]**. Dalam PRD ini, setiap requirement diberi prioritas P0 (wajib untuk demo end-to-end) atau P1 (wajib MVP, dikerjakan setelah P0).

## 4. User Stories

**Wisatawan**

- Sebagai wisatawan, saya ingin melihat daftar destinasi beserta tarif, jam buka, dan lokasinya, supaya saya bisa merencanakan kunjungan.
- Sebagai wisatawan, saya ingin membeli tiket untuk tanggal tertentu dengan QRIS, supaya saya tidak perlu antre membayar tunai.
- Sebagai wisatawan, saya ingin membeli paket yang mencakup beberapa destinasi, supaya lebih praktis dan terjangkau.
- Sebagai wisatawan, saya ingin tiket QR tetap bisa dibuka tanpa sinyal, supaya saya bisa masuk di lokasi yang sinyalnya lemah.
- Sebagai wisatawan, saya ingin memesan homestay dan pemandu lokal, supaya perjalanan saya terorganisir di satu tempat.
- Sebagai wisatawan asing, saya ingin memakai antarmuka bahasa Inggris, supaya saya paham seluruh alur.

**Petugas gerbang**

- Sebagai petugas gerbang, saya ingin memindai QR dan langsung melihat valid atau tidaknya, supaya antrean cepat.
- Sebagai petugas gerbang, saya ingin tetap bisa memindai saat offline dan data tersinkron nanti, supaya pekerjaan tidak terhenti oleh sinyal.

**Pengelola destinasi**

- Sebagai pengelola destinasi, saya ingin melihat jumlah pengunjung dan kuota hari ini, supaya saya bisa mengatur kapasitas.

**Mitra homestay/pemandu**

- Sebagai mitra, saya ingin mendaftarkan layanan, harga, dan ketersediaan, supaya wisatawan bisa memesan saya.
- Sebagai mitra, saya ingin menerima atau menolak pesanan, supaya jadwal saya tidak bentrok.

**Admin Dinas**

- Sebagai admin, saya ingin mengelola destinasi, tarif, kuota, dan paket, supaya data selalu mutakhir.
- Sebagai admin, saya ingin mengekspor laporan penerimaan per destinasi dan periode, supaya bisa diserahkan ke Bapenda.
- Sebagai admin, saya ingin memverifikasi dan menyetujui pendaftaran mitra, supaya hanya mitra sah yang tampil.

**Pembaca dashboard**

- Sebagai pimpinan/Bapenda, saya ingin dashboard read-only pengunjung dan pendapatan, supaya bisa memantau tanpa mengubah data.

## 5. Daftar Fitur

### MVP

- F1. Autentikasi dan peran (6 peran, RBAC)
- F2. Katalog destinasi (wisatawan, bilingual)
- F3. Pembelian tiket tunggal dengan pilihan tanggal dan jumlah
- F4. Paket wisata lintas destinasi
- F5. Pembayaran (mode sandbox untuk demo, antarmuka gateway siap produksi)
- F6. Tiket QR (bertanda tangan, sekali pakai, dapat disimpan offline)
- F7. Scan gerbang (online dan offline-first dengan sinkronisasi)
- F8. Dashboard pengunjung dan pendapatan (real-time mendekati)
- F9. Mitra: registrasi, verifikasi, listing homestay/pemandu, booking
- F10. Admin: kelola destinasi, tarif, kuota, paket; ekspor laporan
- F11. Dua bahasa (ID/EN) dan PWA
- F12. Footer wajib: logo Pemda, logo Universitas Teknokrat Indonesia, teks hak cipta

### v2

- Program loyalitas dan poin
- Rekomendasi itinerary otomatis
- Ulasan dan rating wisatawan
- Notifikasi WhatsApp
- Integrasi data ke sistem keuangan daerah

### Nanti

- Aplikasi native
- Bahasa daerah (Batak)
- Analitik prediksi kunjungan
- Integrasi transportasi dan marketplace UMKM

## 6. Functional Requirements (MVP)

### F1. Autentikasi dan peran

- FR-1.1 (P0): Wisatawan mendaftar dengan email dan kata sandi; kata sandi di-hash dengan argon2.
- FR-1.2 (P0): Peran: wisatawan, petugas, pengelola, mitra, admin, pembaca. Akses endpoint dibatasi per peran (RBAC); pelanggaran mengembalikan 403.
- FR-1.3 (P0): Sesi berbasis token dengan masa berlaku; logout mencabut sesi.
- FR-1.4 (P1): Pembatasan percobaan login (rate limit) dan penguncian sementara.
- FR-1.5 (P1): Akun petugas, pengelola, dan pembaca hanya dibuat oleh admin.
- Metode login selain email (Google, nomor telepon) belum ditentukan **[OQ-4]**.

### F2. Katalog destinasi

- FR-2.1 (P0): Daftar destinasi dengan nama, deskripsi (ID/EN), foto, alamat, koordinat, jam buka, tarif, kuota harian.
- FR-2.2 (P0): Halaman detail destinasi dan tombol beli tiket.
- FR-2.3 (P1): Pencarian dan filter berdasarkan kategori.
- FR-2.4 (P1): Peta lokasi destinasi. Penyedia peta belum ditentukan **[OQ-5]**.
- Daftar destinasi, tarif, dan foto asli harus dari Dinas Pariwisata; sebelum tersedia, demo memakai data contoh yang diberi label jelas **[OQ-6]**.

### F3. Tiket tunggal

- FR-3.1 (P0): Wisatawan memilih destinasi, tanggal kunjungan, dan jumlah per kategori tarif.
- FR-3.2 (P0): Sistem menolak pembelian jika kuota tanggal tersebut tidak cukup, dan menampilkan sisa kuota.
- FR-3.3 (P0): Pesanan dibuat berstatus `menunggu_bayar` dengan batas waktu pembayaran; kuota ditahan selama batas itu.
- FR-3.4 (P0): Saat batas waktu lewat tanpa bayar, pesanan menjadi `kedaluwarsa` dan kuota dilepas.
- Kategori tarif (dewasa, anak, mancanegara, rombongan) dan batas waktu pembayaran belum ditentukan **[OQ-7]**.

### F4. Paket wisata lintas destinasi

- FR-4.1 (P0): Admin membuat paket berisi satu atau lebih destinasi, harga paket, dan masa berlaku.
- FR-4.2 (P0): Pembelian paket menghasilkan satu tiket per destinasi dalam paket.
- FR-4.3 (P1): Paket dapat mensyaratkan urutan atau hari kunjungan berbeda.
- Cara pembagian pendapatan paket antar destinasi untuk keperluan PAD belum ditentukan **[OQ-8]**.

### F5. Pembayaran

- FR-5.1 (P0): Mode sandbox: pembayaran disimulasikan dan statusnya dapat diubah lewat halaman uji khusus yang hanya aktif di lingkungan non-produksi.
- FR-5.2 (P1): Antarmuka penyedia pembayaran diabstraksikan, sehingga gateway (QRIS/virtual account) dapat dipasang tanpa mengubah alur pesanan.
- FR-5.3 (P0): Webhook pembayaran diverifikasi tanda tangannya dan bersifat idempoten (pengiriman ganda tidak membuat tiket ganda).
- FR-5.4 (P1): Pengembalian dana untuk pesanan yang dibatalkan sesuai kebijakan.
- Gateway yang dipakai, biaya transaksi, dan kebijakan refund belum ditentukan **[OQ-9]**. Pembayaran uang sungguhan memerlukan akun dan izin resmi pemerintah daerah **[OQ-10]**.

### F6. Tiket QR

- FR-6.1 (P0): Setelah pembayaran lunas, sistem menerbitkan tiket dengan kode unik dan QR yang memuat token bertanda tangan HMAC-SHA256.
- FR-6.2 (P0): Kode tiket bersifat UNIK di database; satu tiket hanya bisa berstatus `dipakai` sekali.
- FR-6.3 (P0): Tiket dapat dilihat di akun dan diunduh/disimpan offline lewat PWA.
- FR-6.4 (P1): Tiket berlaku hanya pada tanggal kunjungan dan destinasi yang tertera.
- FR-6.5 (P1): Tiket dapat dikirim ke email.

### F7. Scan gerbang

- FR-7.1 (P0): Petugas memindai QR dengan kamera ponsel di halaman web/PWA; hasil: valid, sudah dipakai, kedaluwarsa, salah destinasi, atau tidak dikenal.
- FR-7.2 (P0): Saat online, validasi dilakukan ke server dan tiket langsung ditandai `dipakai`.
- FR-7.3 (P1): Mode offline: perangkat menyimpan daftar tiket valid hari itu untuk destinasinya dan mencatat scan secara lokal, lalu mengirim saat online kembali.
- FR-7.4 (P1): Konflik sinkronisasi (tiket sama dipindai di dua perangkat offline) diselesaikan dengan aturan scan tertua menang, dan konflik dicatat untuk ditinjau admin.
- FR-7.5 (P0): Setiap scan dicatat dengan waktu, petugas, perangkat, dan hasil.
- Cara menangani tiket yang valid tetapi tidak ada di cache offline belum ditentukan **[OQ-11]**.

### F8. Dashboard

- FR-8.1 (P0): Menampilkan pengunjung dan pendapatan hari ini, 7 hari, dan 30 hari, per destinasi.
- FR-8.2 (P0): Pembaca hanya dapat melihat; tidak ada tombol ubah data.
- FR-8.3 (P1): Pembaruan otomatis tanpa muat ulang, dengan jeda pembaruan paling lama 60 detik **[OQ-12]**.
- FR-8.4 (P1): Pengelola destinasi hanya melihat destinasinya sendiri.
- Definisi "pengunjung" (tiket terjual atau tiket terpindai) harus ditetapkan; dashboard menampilkan keduanya sampai ada keputusan **[OQ-13]**.

### F9. Mitra homestay dan pemandu

- FR-9.1 (P0): Mitra mendaftar dengan data usaha dan dokumen pendukung; status `menunggu`, `disetujui`, atau `ditolak`.
- FR-9.2 (P0): Admin memverifikasi pendaftaran; hanya mitra disetujui yang tampil di katalog.
- FR-9.3 (P0): Mitra mengelola layanan: nama, deskripsi (ID/EN), harga, kapasitas, ketersediaan tanggal.
- FR-9.4 (P1): Wisatawan memesan layanan mitra untuk rentang tanggal; mitra menerima atau menolak dalam batas waktu tertentu.
- FR-9.5 (P1): Pesanan mitra yang tidak direspons hingga batas waktu menjadi `kedaluwarsa`.
- Apakah pembayaran booking homestay/pemandu melalui platform atau langsung ke mitra, dan apakah ada komisi, belum ditentukan **[OQ-14]**.

### F10. Admin

- FR-10.1 (P0): CRUD destinasi, tarif, kuota harian, dan paket.
- FR-10.2 (P0): Perubahan tarif hanya berlaku untuk pesanan baru; pesanan lama tidak berubah.
- FR-10.3 (P1): Ekspor laporan penerimaan (CSV dan PDF) per destinasi dan periode.
- FR-10.4 (P1): Log audit untuk setiap perubahan tarif, kuota, dan peran pengguna.

### F11. Dua bahasa dan PWA

- FR-11.1 (P0): Seluruh teks antarmuka dan konten katalog tersedia dalam Indonesia dan Inggris; pengguna dapat berpindah bahasa kapan saja.
- FR-11.2 (P1): Aplikasi dapat dipasang (PWA) dengan manifest dan service worker; halaman tiket dan scanner berfungsi offline.

### F12. Footer wajib

- FR-12.1 (P0): Footer di setiap halaman memuat logo Pemda Kabupaten Tapanuli Utara, logo Universitas Teknokrat Indonesia, dan teks "Copyright©2026 by Pelita Julia Silaban" serta "Dr. Erliyan Redy Susanto, M.Kom".
- File logo resmi perlu disediakan dan penggunaan logo Pemda perlu izin **[OQ-15]**.

## 7. Sketsa Data Model (PostgreSQL)

- **users**: id (UUID), email (unik), password_hash, nama, role (wisatawan|petugas|pengelola|mitra|admin|pembaca), bahasa, aktif, created_at
- **destinations**: id, nama_id, nama_en, deskripsi_id, deskripsi_en, alamat, lat, lng, jam_buka (JSONB), foto_url, kuota_harian, aktif
- **destination_managers**: user_id, destination_id (hubungan pengelola dan petugas ke destinasi)
- **tariffs**: id, destination_id, kategori, harga (integer, rupiah), berlaku_dari, berlaku_sampai
- **packages**: id, nama_id, nama_en, harga, masa_berlaku_hari, aktif
- **package_items**: package_id, destination_id, urutan
- **orders**: id, user_id, tipe (tiket|paket|booking_mitra), total, status (menunggu_bayar|lunas|kedaluwarsa|dibatalkan|refund), tanggal_kunjungan, expires_at, created_at
- **order_items**: id, order_id, destination_id atau package_id atau partner_service_id, kategori_tarif, qty, harga_satuan
- **payments**: id, order_id, provider, provider_ref (unik), status, jumlah, raw_payload (JSONB), paid_at
- **tickets**: id, order_item_id, destination_id, kode (unik), signature, tanggal_berlaku, status (aktif|dipakai|kedaluwarsa|batal), used_at
- **scans**: id, ticket_id (nullable), kode_dibaca, petugas_id, device_id, hasil, scanned_at, synced_at, offline (boolean)
- **daily_quota**: destination_id, tanggal, terjual, ditahan (kunci pada destination_id + tanggal untuk mencegah oversell)
- **partners**: id, user_id, nama_usaha, tipe (homestay|pemandu), status_verifikasi, dokumen_url
- **partner_services**: id, partner_id, nama_id, nama_en, harga, kapasitas, aktif
- **partner_availability**: partner_service_id, tanggal, tersedia
- **partner_bookings**: id, order_item_id, partner_service_id, tanggal_mulai, tanggal_selesai, status (menunggu|diterima|ditolak|kedaluwarsa)
- **audit_logs**: id, actor_id, aksi, entitas, entitas_id, sebelum (JSONB), sesudah (JSONB), created_at

**Constraint kunci:** UNIQUE pada tickets.kode dan payments.provider_ref; CHECK terjual + ditahan ≤ kuota; transaksi database untuk pembelian dan pemakaian tiket.

## 8. Edge Case dan Failure State

- **Oversell kuota:** dua pembeli serentak membeli kuota terakhir; hanya satu berhasil lewat penguncian baris pada daily_quota.
- **Pembayaran terlambat:** pembayaran masuk setelah pesanan kedaluwarsa; sistem menandai untuk refund atau penerbitan manual, bukan menerbitkan tiket otomatis. Kebijakannya belum ditentukan **[OQ-16]**.
- **Webhook ganda atau tidak berurutan:** diproses idempoten berdasarkan provider_ref.
- **Webhook palsu:** ditolak jika tanda tangan tidak valid, dan dicatat.
- **Tiket dipindai dua kali:** scan kedua ditolak dengan info waktu dan lokasi scan pertama.
- **QR difoto/digandakan:** hanya scan pertama yang valid.
- **QR dipalsukan:** tanda tangan HMAC tidak cocok, ditolak.
- **Salah destinasi atau tanggal:** ditolak dengan alasan yang jelas.
- **Offline lama:** perangkat scanner offline berhari-hari; cache kedaluwarsa dan petugas diminta sinkronisasi. Batas waktu cache belum ditentukan **[OQ-11]**.
- **Konflik sinkronisasi offline:** dua perangkat memindai tiket yang sama; lihat FR-7.4.
- **Gateway mati:** pesanan tetap tersimpan; pengguna diberi pesan dan dapat mencoba ulang tanpa membuat pesanan baru.
- **Destinasi ditutup mendadak (cuaca/bencana):** admin menutup destinasi pada tanggal tertentu; tiket terdampak diberi opsi ganti tanggal atau refund. Kebijakan belum ditentukan **[OQ-17]**.
- **Mitra tidak merespons:** pesanan kedaluwarsa dan pembayaran dikembalikan jika sudah dibayar.
- **Perubahan tarif saat pesanan berjalan:** harga pesanan tetap memakai harga saat pesanan dibuat.
- **Data pribadi:** permintaan hapus akun harus mematuhi UU PDP; tiket dan transaksi tetap disimpan sesuai kewajiban pencatatan keuangan, dengan data pribadi dianonimkan. Masa retensi belum ditentukan **[OQ-18]**.
- **Peran dicabut saat sesi aktif:** akses langsung gugur pada permintaan berikutnya.
- **Lonjakan trafik (libur panjang):** penerbitan tiket dan scan harus tetap berfungsi; target beban pada bagian Success Metrics.

## 9. Success Metrics

**Metrik fungsional (kriteria selesai untuk UTS)**

- Satu alur end-to-end berjalan di Vercel dengan data seed: katalog → beli tiket/paket → bayar (sandbox) → tiket QR → scan → tampil di dashboard.
- Seluruh 6 peran dapat login dan hanya mengakses fiturnya.
- Seluruh teks tersedia dalam ID dan EN; aplikasi dapat dipasang sebagai PWA.
- Footer wajib tampil di semua halaman.
- Jumlah destinasi pada data demo: belum ditentukan **[OQ-6]**.

**Metrik kualitas (target usulan, perlu disetujui)**

- 0 tiket yang bisa dipakai dua kali dalam uji (minimal 100 percobaan scan ganda dan serentak).
- 0 oversell kuota dalam uji beban serentak.
- Waktu respons scan online p95 di bawah 500 ms.
- Cakupan test otomatis untuk alur pembelian, pembayaran, dan scan.
- 0 temuan keamanan tingkat tinggi/kritis tersisa setelah audit.

**Metrik produk (pasca peluncuran, bukan syarat UTS)**

- Persentase tiket terjual digital terhadap total pengunjung.
- Selisih jumlah pengunjung tercatat sebelum dan sesudah sistem.
- Waktu rata-rata proses masuk per pengunjung di gerbang.
- Jumlah mitra aktif dan jumlah booking mitra.
- Baseline dan target angka belum tersedia **[OQ-1]**.

## 10. Open Questions

- **OQ-1:** Berapa data baseline pengunjung dan penerimaan retribusi per destinasi saat ini, dan siapa sumbernya?
- **OQ-2:** Apakah persona dan alur ini sudah divalidasi dengan Dinas Pariwisata/pengelola nyata, atau murni skenario UTS?
- **OQ-3:** Karena semua fitur masuk MVP, apa urutan prioritas dan fitur mana yang boleh turun ke v2 jika waktu tidak cukup?
- **OQ-4:** Metode login apa saja yang dipakai selain email dan kata sandi?
- **OQ-5:** Penyedia peta apa yang dipakai (mis. OpenStreetMap atau Google Maps) dan siapa yang menanggung biayanya?
- **OQ-6:** Berapa destinasi dan data apa yang dipakai di demo; apakah ada data resmi dari dinas?
- **OQ-7:** Apa saja kategori tarif dan berapa batas waktu pembayaran serta penahanan kuota?
- **OQ-8:** Bagaimana pendapatan paket dibagi antar destinasi untuk pelaporan PAD?
- **OQ-9:** Gateway pembayaran mana yang dipilih, berapa biaya transaksinya, dan apa kebijakan refund?
- **OQ-10:** Apakah ada izin dan rekening resmi pemda untuk menerima pembayaran sungguhan, atau demo tetap sandbox?
- **OQ-11:** Bagaimana perlakuan scan offline untuk tiket yang tidak ada di cache, dan berapa lama cache offline berlaku?
- **OQ-12:** Apakah "real-time" cukup dengan pembaruan hingga 60 detik?
- **OQ-13:** "Pengunjung" didefinisikan sebagai tiket terjual atau tiket terpindai?
- **OQ-14:** Apakah pembayaran booking mitra lewat platform, dan apakah ada komisi untuk daerah?
- **OQ-15:** Apakah file logo resmi Pemda dan Universitas Teknokrat Indonesia sudah tersedia dan penggunaannya diizinkan?
- **OQ-16:** Apa kebijakan untuk pembayaran yang masuk setelah pesanan kedaluwarsa?
- **OQ-17:** Apa kebijakan saat destinasi ditutup mendadak (ganti tanggal atau refund)?
- **OQ-18:** Berapa masa retensi data pribadi dan transaksi, dan siapa pengendali data menurut UU PDP?
- **OQ-19:** Bagaimana hosting di Vercel menangani backend Rust dan PostgreSQL (fungsi serverless Rust atau layanan terpisah, dan penyedia PostgreSQL terkelola)? Keputusan ini mempengaruhi mode offline, koneksi database, dan biaya, serta perlu divalidasi pada tahap desain teknis.
