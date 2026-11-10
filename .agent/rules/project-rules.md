# Aturan Proyek: Taput Wisata Pass

Baca `docs/PRD.md` sebelum mengubah kode apa pun. PRD adalah sumber kebenaran.

## Teknologi (wajib)
- Backend: Rust (Axum + Tokio). Akses database: SQLx. Database: PostgreSQL.
- Frontend: HTML, CSS, JavaScript tanpa framework berat. PWA dengan service worker. Dua bahasa: Indonesia dan Inggris.
- Deploy akhir: Vercel (backend Rust sebagai Vercel Functions memakai crate `vercel_runtime`, atau layanan terpisah). Jangan ubah arsitektur deploy sebelum diminta.
- Skema database ada di `migrations/`. Setiap perubahan skema = file migrasi baru, jangan edit migrasi lama.

## Desain UI
Acuan tampilan ada di `design/` (10 layar HTML hasil ekspor Stitch, indeks di `design/README.md`). Pertahankan palet dan gaya, tetapi bangun ulang di `public/` tanpa Tailwind CDN. PRD dan aturan di file ini menang jika bertentangan dengan desain.

## Footer wajib (FR-12.1)
Setiap halaman HTML harus memuat footer berisi:
- Logo Pemda: `/assets/logo-pemda-taput.png`
- Logo Universitas Teknokrat Indonesia: `/assets/logo-uti.jpg`
- Teks persis: `Copyright©2026 by Pelita Julia Silaban dan Dr. Erliyan Redy Susanto, M.Kom`
Footer tidak boleh menutupi tombol atau area scan. Aset footer masuk cache service worker.

## Aturan keamanan
- Hash kata sandi dengan argon2. Jangan simpan kata sandi polos.
- Semua query memakai parameter (SQLx), tidak ada penggabungan string SQL.
- Cek peran (RBAC) di setiap endpoint. Pembaca dashboard hanya read-only.
- QR berisi token bertanda tangan HMAC-SHA256; tiket hanya bisa dipakai sekali lewat `UPDATE ... WHERE status='aktif' RETURNING`.
- Webhook pembayaran: verifikasi tanda tangan dan idempoten (`ON CONFLICT (provider_ref) DO NOTHING`).
- Kuota: kunci baris dengan `SELECT ... FOR UPDATE` di dalam transaksi.
- Rahasia hanya dari environment variable (`.env`), jangan di-commit.
- Simpan waktu sebagai `timestamptz`; hitung "hari ini" dengan zona waktu Asia/Jakarta.

## Cara bekerja
- Kerjakan per fase kecil. Setelah tiap fase jalankan `cargo check` dan `cargo test`, lalu jelaskan apa yang berubah.
- Jangan menambah fitur di luar PRD. Jika requirement ambigu atau tercantum sebagai Open Question (OQ-n), jangan mengarang: pakai asumsi paling sederhana, tandai dengan komentar `// OQ-n` dan laporkan di akhir fase.
- Tulis test untuk alur kritis: kuota (tidak oversell), tiket sekali pakai, webhook ganda, RBAC.
- Komentar kode dan pesan commit dalam bahasa Indonesia.
