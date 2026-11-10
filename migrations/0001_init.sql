-- Skema awal Taput Wisata Pass (sesuai PRD bagian 7)
-- Semua waktu disimpan sebagai timestamptz (UTC); "hari ini" dihitung dengan zona waktu Asia/Jakarta.

CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE users (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email         TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  nama          TEXT NOT NULL,
  role          TEXT NOT NULL CHECK (role IN ('wisatawan','petugas','pengelola','mitra','admin','pembaca')),
  bahasa        TEXT NOT NULL DEFAULT 'id' CHECK (bahasa IN ('id','en')),
  aktif         BOOLEAN NOT NULL DEFAULT TRUE,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE destinations (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nama_id       TEXT NOT NULL,
  nama_en       TEXT NOT NULL,
  deskripsi_id  TEXT,
  deskripsi_en  TEXT,
  alamat        TEXT,
  lat           DOUBLE PRECISION,
  lng           DOUBLE PRECISION,
  jam_buka      JSONB,
  foto_url      TEXT,
  kuota_harian  INTEGER NOT NULL CHECK (kuota_harian >= 0),
  aktif         BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE destination_managers (
  user_id        UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  destination_id UUID NOT NULL REFERENCES destinations(id) ON DELETE CASCADE,
  PRIMARY KEY (user_id, destination_id)
);

CREATE TABLE tariffs (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  destination_id UUID NOT NULL REFERENCES destinations(id) ON DELETE CASCADE,
  kategori       TEXT NOT NULL,
  harga          INTEGER NOT NULL CHECK (harga >= 0),
  berlaku_dari   DATE NOT NULL,
  berlaku_sampai DATE
);

CREATE TABLE packages (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nama_id           TEXT NOT NULL,
  nama_en           TEXT NOT NULL,
  harga             INTEGER NOT NULL CHECK (harga >= 0),
  masa_berlaku_hari INTEGER NOT NULL CHECK (masa_berlaku_hari > 0),
  aktif             BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE package_items (
  package_id     UUID NOT NULL REFERENCES packages(id) ON DELETE CASCADE,
  destination_id UUID NOT NULL REFERENCES destinations(id),
  urutan         INTEGER NOT NULL DEFAULT 1,
  PRIMARY KEY (package_id, destination_id)
);

CREATE TABLE partners (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id            UUID NOT NULL REFERENCES users(id),
  nama_usaha         TEXT NOT NULL,
  tipe               TEXT NOT NULL CHECK (tipe IN ('homestay','pemandu')),
  status_verifikasi  TEXT NOT NULL DEFAULT 'menunggu' CHECK (status_verifikasi IN ('menunggu','disetujui','ditolak')),
  dokumen_url        TEXT
);

CREATE TABLE partner_services (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  partner_id UUID NOT NULL REFERENCES partners(id) ON DELETE CASCADE,
  nama_id    TEXT NOT NULL,
  nama_en    TEXT NOT NULL,
  harga      INTEGER NOT NULL CHECK (harga >= 0),
  kapasitas  INTEGER NOT NULL CHECK (kapasitas > 0),
  aktif      BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE partner_availability (
  partner_service_id UUID NOT NULL REFERENCES partner_services(id) ON DELETE CASCADE,
  tanggal            DATE NOT NULL,
  tersedia           BOOLEAN NOT NULL DEFAULT TRUE,
  PRIMARY KEY (partner_service_id, tanggal)
);

CREATE TABLE orders (
  id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id           UUID NOT NULL REFERENCES users(id),
  tipe              TEXT NOT NULL CHECK (tipe IN ('tiket','paket','booking_mitra')),
  total             INTEGER NOT NULL CHECK (total >= 0),
  status            TEXT NOT NULL DEFAULT 'menunggu_bayar'
                    CHECK (status IN ('menunggu_bayar','lunas','kedaluwarsa','dibatalkan','refund')),
  tanggal_kunjungan DATE,
  expires_at        TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE order_items (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id           UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  destination_id     UUID REFERENCES destinations(id),
  package_id         UUID REFERENCES packages(id),
  partner_service_id UUID REFERENCES partner_services(id),
  kategori_tarif     TEXT,
  qty                INTEGER NOT NULL CHECK (qty > 0),
  harga_satuan       INTEGER NOT NULL CHECK (harga_satuan >= 0)
);

CREATE TABLE payments (
  id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id     UUID NOT NULL REFERENCES orders(id),
  provider     TEXT NOT NULL,
  provider_ref TEXT NOT NULL,
  status       TEXT NOT NULL,
  jumlah       INTEGER NOT NULL CHECK (jumlah >= 0),
  raw_payload  JSONB,
  paid_at      TIMESTAMPTZ,
  CONSTRAINT payments_ref_uniq UNIQUE (provider_ref)
);

CREATE TABLE tickets (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_item_id   UUID NOT NULL REFERENCES order_items(id),
  destination_id  UUID NOT NULL REFERENCES destinations(id),
  kode            TEXT NOT NULL,
  signature       TEXT NOT NULL,
  tanggal_berlaku DATE NOT NULL,
  status          TEXT NOT NULL DEFAULT 'aktif' CHECK (status IN ('aktif','dipakai','kedaluwarsa','batal')),
  used_at         TIMESTAMPTZ,
  CONSTRAINT tickets_kode_uniq UNIQUE (kode)
);

CREATE TABLE scans (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  ticket_id   UUID REFERENCES tickets(id),
  kode_dibaca TEXT NOT NULL,
  petugas_id  UUID NOT NULL REFERENCES users(id),
  device_id   TEXT,
  hasil       TEXT NOT NULL,
  scanned_at  TIMESTAMPTZ NOT NULL,
  synced_at   TIMESTAMPTZ,
  offline     BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE daily_quota (
  destination_id UUID NOT NULL REFERENCES destinations(id) ON DELETE CASCADE,
  tanggal        DATE NOT NULL,
  kuota          INTEGER NOT NULL CHECK (kuota >= 0),
  terjual        INTEGER NOT NULL DEFAULT 0 CHECK (terjual >= 0),
  ditahan        INTEGER NOT NULL DEFAULT 0 CHECK (ditahan >= 0),
  PRIMARY KEY (destination_id, tanggal),
  CONSTRAINT quota_tidak_melebihi CHECK (terjual + ditahan <= kuota)
);

CREATE TABLE partner_bookings (
  id                 UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  order_item_id      UUID NOT NULL REFERENCES order_items(id),
  partner_service_id UUID NOT NULL REFERENCES partner_services(id),
  tanggal_mulai      DATE NOT NULL,
  tanggal_selesai    DATE NOT NULL,
  status             TEXT NOT NULL DEFAULT 'menunggu'
                     CHECK (status IN ('menunggu','diterima','ditolak','kedaluwarsa')),
  CHECK (tanggal_selesai >= tanggal_mulai)
);

CREATE TABLE audit_logs (
  id         UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_id   UUID REFERENCES users(id),
  aksi       TEXT NOT NULL,
  entitas    TEXT NOT NULL,
  entitas_id TEXT,
  sebelum    JSONB,
  sesudah    JSONB,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_tickets_destination ON tickets (destination_id, tanggal_berlaku);
CREATE INDEX idx_scans_scanned_at   ON scans (scanned_at);
CREATE INDEX idx_payments_paid_at   ON payments (paid_at);
CREATE INDEX idx_orders_user        ON orders (user_id, created_at DESC);
