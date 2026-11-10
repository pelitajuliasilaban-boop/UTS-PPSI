# Taput Wisata Pass

Platform tiket digital QR lintas destinasi wisata Kabupaten Tapanuli Utara.
Proyek UTS Proyek Pengembangan Sistem Informasi: Pelita Julia Silaban (24311046).

Teknologi: Rust (Axum, SQLx) dan PostgreSQL. Deploy: Vercel.

## Isi folder
- `AGENTS.md` dan `.agent/rules/project-rules.md`: aturan untuk AI agent (stack, keamanan, footer wajib).
- `docs/PRD.md`: PRD lengkap.
- `docs/PROMPTS_ANTIGRAVITY.md`: prompt per fase untuk Antigravity.
- `migrations/0001_init.sql`: skema PostgreSQL sesuai PRD.
- `src/main.rs`: kerangka awal server (endpoint `/api/health` dan penyaji file statis).
- `design/`: 10 layar desain Stitch (HTML) sebagai acuan tampilan Fase 7, indeks di `design/README.md`.
- `public/`: kerangka frontend dengan footer wajib (dua logo dan teks copyright).
- `docker-compose.yml`: PostgreSQL untuk pengembangan lokal.

## Menjalankan kerangka awal
1. Pasang Rust (https://rustup.rs) dan Docker.
2. Salin `.env.example` menjadi `.env`.
3. Jalankan database: `docker compose up -d`
4. Jalankan server: `cargo run`
5. Buka http://localhost:3000 dan http://localhost:3000/api/health

Kerangka ini belum menjalankan migrasi dan belum terhubung ke database; itu dikerjakan di Fase 1 pada `docs/PROMPTS_ANTIGRAVITY.md`.

## Membuka di Antigravity
File > Open Folder, pilih folder `taput-wisata-pass`. Buka `design/*.html` di browser untuk melihat desain. Lalu ikuti prompt di `docs/PROMPTS_ANTIGRAVITY.md` mulai dari Fase 0.
