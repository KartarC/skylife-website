-- ============================================
-- SkyLife Aircrafts — Supabase Database Schema
-- Run this once in your Supabase SQL Editor
-- ============================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ─── LISTINGS TABLE ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS listings (
  id            UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  created_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  make          TEXT NOT NULL,
  model         TEXT NOT NULL,
  year          INTEGER NOT NULL,
  registration  TEXT,
  price         NUMERIC(12, 2) NOT NULL,
  price_display TEXT,
  total_time    INTEGER,
  engine_time   INTEGER,
  category      TEXT CHECK (category IN ('piston','turboprop','light_jet','heavy_jet','helicopter')),
  location      TEXT,
  specs         JSONB DEFAULT '{}',
  description   TEXT,
  photos        TEXT[],
  status        TEXT DEFAULT 'active' CHECK (status IN ('active','pending','sold','draft')),
  featured      BOOLEAN DEFAULT FALSE
);

-- ─── LEADS TABLE (buyer inquiries) ───────────────────────────────────────────
CREATE TABLE IF NOT EXISTS leads (
  id                UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  created_at        TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  name              TEXT NOT NULL,
  email             TEXT NOT NULL,
  phone             TEXT,
  aircraft_interest TEXT,
  listing_id        UUID REFERENCES listings(id) ON DELETE SET NULL,
  budget            TEXT,
  message           TEXT,
  status            TEXT DEFAULT 'new' CHECK (status IN ('new','contacted','qualified','closed_won','closed_lost')),
  notes             TEXT,
  source            TEXT DEFAULT 'website'
);

-- ─── AIRCRAFT SUBMISSIONS (sellers listing their aircraft) ───────────────────
CREATE TABLE IF NOT EXISTS aircraft_submissions (
  id                   UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  created_at           TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  -- Owner contact
  owner_name           TEXT NOT NULL,
  email                TEXT NOT NULL,
  phone                TEXT,
  -- Aircraft details
  make                 TEXT NOT NULL,
  model                TEXT NOT NULL,
  year                 INTEGER,
  registration         TEXT,
  category             TEXT CHECK (category IN ('piston','turboprop','light_jet','heavy_jet','helicopter')),
  total_time           INTEGER,
  engine_time          INTEGER,
  num_seats            INTEGER,
  avionics             TEXT,
  location             TEXT,
  -- Pricing
  asking_price         NUMERIC(12, 2),
  -- Condition & extras
  condition            TEXT CHECK (condition IN ('excellent','good','fair','project')),
  description          TEXT,
  additional_equipment TEXT,
  -- Admin
  status               TEXT DEFAULT 'pending' CHECK (status IN ('pending','reviewing','listed','rejected'))
);

-- ─── VALUATION REQUESTS (sell page) ──────────────────────────────────────────
CREATE TABLE IF NOT EXISTS valuation_requests (
  id           UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  created_at   TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  name         TEXT NOT NULL,
  email        TEXT NOT NULL,
  phone        TEXT,
  make         TEXT NOT NULL,
  model        TEXT NOT NULL,
  year         INTEGER,
  total_time   INTEGER,
  engine_time  INTEGER,
  condition    TEXT CHECK (condition IN ('excellent','good','fair','project')),
  location     TEXT,
  asking_price NUMERIC(12, 2),
  message      TEXT,
  status       TEXT DEFAULT 'new' CHECK (status IN ('new','contacted','completed'))
);

-- ─── CONTACT MESSAGES (services, about, general) ─────────────────────────────
CREATE TABLE IF NOT EXISTS contact_messages (
  id         UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  name       TEXT NOT NULL,
  email      TEXT NOT NULL,
  phone      TEXT,
  subject    TEXT,
  message    TEXT NOT NULL,
  source     TEXT,
  status     TEXT DEFAULT 'new' CHECK (status IN ('new','read','replied'))
);

-- ─── ROW LEVEL SECURITY ───────────────────────────────────────────────────────

ALTER TABLE listings ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public can view active listings"
  ON listings FOR SELECT USING (status = 'active');

ALTER TABLE leads ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public can submit leads"
  ON leads FOR INSERT WITH CHECK (true);

ALTER TABLE aircraft_submissions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public can submit aircraft"
  ON aircraft_submissions FOR INSERT WITH CHECK (true);

ALTER TABLE valuation_requests ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public can submit valuation requests"
  ON valuation_requests FOR INSERT WITH CHECK (true);

ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Public can submit contact messages"
  ON contact_messages FOR INSERT WITH CHECK (true);

-- ─── INDEXES ──────────────────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_listings_status       ON listings(status);
CREATE INDEX IF NOT EXISTS idx_listings_category     ON listings(category);
CREATE INDEX IF NOT EXISTS idx_listings_price        ON listings(price);
CREATE INDEX IF NOT EXISTS idx_listings_featured     ON listings(featured);
CREATE INDEX IF NOT EXISTS idx_leads_status          ON leads(status);
CREATE INDEX IF NOT EXISTS idx_leads_created_at      ON leads(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_submissions_status    ON aircraft_submissions(status);
CREATE INDEX IF NOT EXISTS idx_submissions_created   ON aircraft_submissions(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_valuations_status     ON valuation_requests(status);
CREATE INDEX IF NOT EXISTS idx_contacts_status       ON contact_messages(status);
CREATE INDEX IF NOT EXISTS idx_contacts_created      ON contact_messages(created_at DESC);

-- ─── SAMPLE DATA ──────────────────────────────────────────────────────────────
INSERT INTO listings (make, model, year, price, price_display, total_time, engine_time, category, location, featured, description, specs) VALUES
  ('Cessna',    '172 Skyhawk',   2018, 285000,  'CAD $285,000',   1240, 480,  'piston',    'Toronto, ON',     TRUE, 'Excellent condition Cessna 172S with Garmin G1000 NXi glass cockpit. Always hangared, meticulously maintained.',     '{"seats":4,"range_nm":640,"cruise_speed":122,"avionics":"Garmin G1000 NXi"}'),
  ('Beechcraft','King Air C90',  2015, 1850000, 'CAD $1,850,000', 3200, 900,  'turboprop', 'Ottawa, ON',      TRUE, 'Low-time King Air C90GTx with upgraded PT6A-135A engines. Corporate configured, 6-passenger interior.',          '{"seats":6,"range_nm":1000,"cruise_speed":272,"avionics":"Proline 21"}'),
  ('Cirrus',    'SR22T',         2021, 785000,  'CAD $785,000',    620,  620,  'piston',    'Waterloo, ON',    TRUE, 'Like-new SR22T Generation 6 with FIKI TKS, Perspective+ avionics, CAPS whole-aircraft parachute.',              '{"seats":4,"range_nm":1021,"cruise_speed":213,"avionics":"Garmin Perspective+"}'),
  ('Pilatus',   'PC-12 NGX',     2020, 4200000, 'CAD $4,200,000', 1100, 1100, 'turboprop', 'Vancouver, BC',   TRUE, 'Nearly new PC-12 NGX with Honeywell Primus Apex avionics. Single-engine turboprop utility with airline comfort.','{"seats":9,"range_nm":1803,"cruise_speed":290,"avionics":"Honeywell Primus Apex"}'),
  ('Cessna',    'Citation CJ3+', 2019, 6800000, 'CAD $6,800,000',  890,  890,  'light_jet', 'Calgary, AB',     TRUE, 'Citation CJ3+ with Collins Pro Line 21 avionics. Factory warranty remaining. RVSM equipped.',                    '{"seats":8,"range_nm":2040,"cruise_speed":416,"avionics":"Collins Pro Line 21"}');
