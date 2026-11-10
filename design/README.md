# Desain UI (hasil ekspor Stitch)

Sepuluh layar acuan untuk Fase 7. Setiap file adalah HTML mandiri (Tailwind via CDN, font Google, ikon Material Symbols) dan bisa dibuka langsung di browser untuk dilihat.

| File | Layar | Peran |
|---|---|---|
| `01-homestay-pemandu-mobile.html` | Homestay & Pemandu (mobile): daftar, form reservasi, status booking | Wisatawan |
| `02-homestay-pemandu-desktop.html` | Homestay & Pemandu (web desktop) | Wisatawan |
| `03-masuk-registrasi.html` | Masuk & Registrasi | Semua |
| `04-petugas-gerbang-scanner.html` | Scanner & verifikasi tiket | Petugas |
| `05-dasbor-dinas-pariwisata.html` | Dasbor Dinas Pariwisata | Admin |
| `06-kelola-destinasi-tarif-kuota.html` | Kelola destinasi, tarif, kuota | Admin |
| `07-mitra-laporan-audit.html` | Mitra, laporan, audit | Admin |
| `08-dasbor-bapenda-readonly.html` | Dasbor pemantauan (read-only) | Pembaca |
| `09-panel-mitra.html` | Panel mitra homestay & pemandu | Mitra |
| `10-pengelola-destinasi.html` | Pengelola destinasi | Pengelola |

## Catatan untuk implementasi
- Desain ini **acuan visual**, bukan kode produksi. Ambil palet (primer `#004343`, `#90d2d1`), tipografi (Inter, Plus Jakarta Sans), spasi, dan struktur komponen, lalu bangun ulang di `public/` dengan HTML/CSS/JS tanpa framework berat.
- Jangan pakai Tailwind CDN di produksi: pindahkan token warna dan spasi ke `public/style.css`.
- Gambar `lh3.googleusercontent.com` adalah placeholder; ganti dengan aset lokal dan masukkan ke cache service worker.
- Data di desain hanya contoh. Data nyata harus dari API (PRD).
- Jika desain bertentangan dengan PRD atau `AGENTS.md`, PRD dan `AGENTS.md` yang menang. Footer wajib (FR-12.1) harus tetap sesuai `AGENTS.md`: logo dari `/assets/`, bukan dari URL desain.
- Layar tanpa desain (checkout, tiket QR, detail destinasi, beranda wisatawan) dibuat mengikuti gaya yang sama.
