-- ============================================
-- SkyLife Aircrafts — Supabase Database Schema
-- Run this once in your Supabase SQL Editor
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ─── LISTINGS TABLE ───────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS listings (
  id            UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  created_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at    TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Aircraft identity
  make          TEXT NOT NULL,          -- e.g. "Cessna"
  model         TEXT NOT NULL,          -- e.g. "172 Skyhawk"
  year          INTEGER NOT NULL,       -- e.g. 2018
  registration  TEXT,                   -- e.g. "C-FXYZ"

  -- Pricing
  price         NUMERIC(12, 2) NOT NULL,
  price_display TEXT,                   -- e.g. "CAD $485,000"

  -- Aircraft details
  total_time    INTEGER,               -- Total airframe hours
  engine_time   INTEGER,               -- Engine hours since overhaul
  category      TEXT,                  -- "piston" | "turboprop" | "light_jet" | "heavy_jet" | "helicopter"
  location      TEXT,                  -- e.g. "Toronto, ON"

  -- Specs (stored as JSON for flexibility)
  specs         JSONB DEFAULT '{}',    -- { seats, range_nm, cruise_speed, useful_load, avionics }

  -- Listing content
  description   TEXT,
  photos        TEXT[],                -- Array of photo URLs
  status        TEXT DEFAULT 'active', -- "active" | "pending" | "sold" | "draft"
  featured      BOOLEAN DEFAULT FALSE

);

-- ─── LEADS TABLE ──────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS leads (
  id                UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  created_at        TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

  -- Contact info
  name              TEXT NOT NULL,
  email             TEXT NOT NULL,
  phone             TEXT,

  -- Interest
  aircraft_interest TEXT,             -- What aircraft they're interested in
  listing_id        UUID REFERENCES listings(id) ON DELETE SET NULL,
  budget            TEXT,             -- e.g. "$200K - $500K"
  message           TEXT,

  -- Pipeline
  status            TEXT DEFAULT 'new', -- "new" | "contacted" | "qualified" | "closed_won" | "closed_lost"
  notes             TEXT,
  source            TEXT DEFAULT 'website' -- "website" | "referral" | "flying_club" | "other"
);

-- ─── ROW LEVEL SECURITY ───────────────────────────────────────────────────────

-- Listings: public can read active listings
ALTER TABLE listings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can view active listings"
  ON listings FOR SELECT
  USING (status = 'active');

-- Leads: public can insert (contact form submissions)
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public can submit leads"
  ON leads FOR INSERT
  WITH CHECK (true);

-- ─── INDEXES ──────────────────────────────────────────────────────────────────
CREATE INDEX idx_listings_status    ON listings(status);
CREATE INDEX idx_listings_category  ON listings(category);
CREATE INDEX idx_listings_price     ON listings(price);
CREATE INDEX idx_listings_featured  ON listings(featured);
CREATE INDEX idx_leads_status       ON leads(status);
CREATE INDEX idx_leads_created_at   ON leads(created_at DESC);

-- ─── SAMPLE DATA ──────────────────────────────────────────────────────────────
INSERT INTO listings (make, model, year, price, price_display, total_time, engine_time, category, location, featured, description, specs) VALUES
  ('Cessna',   '172 Skyhawk',  2018, 285000,  'CAD $285,000',  1240, 480,  'piston',    'Toronto, ON',    TRUE,  'Excellent condition Cessna 172S with Garmin G1000 NXi glass cockpit. Always hangared, meticulously maintained.',  '{"seats":4,"range_nm":640,"cruise_speed":122,"avionics":"Garmin G1000 NXi"}'),
  ('Beechcraft','King Air C90', 2015, 1850000, 'CAD $1,850,000', 3200, 900,  'turboprop', 'Ottawa, ON',     TRUE,  'Low-time King Air C90GTx with upgraded PT6A-135A engines. Corporate configured, 6-passenger interior.', '{"seats":6,"range_nm":1000,"cruise_speed":272,"avionics":"Proline 21"}'),
  ('Cirrus',   'SR22T',        2021, 785000,  'CAD $785,000',  620,  620,  'piston',    'Waterloo, ON',   TRUE,  'Like-new SR22T Generation 6 with FIKI TKS, Perspective+ avionics, CAPS whole-aircraft parachute.', '{"seats":4,"range_nm":1021,"cruise_speed":213,"avionics":"Garmin Perspective+"}'),
  ('Pilatus',  'PC-12 NGX',    2020, 4200000, 'CAD $4,200,000', 1100, 1100, 'turboprop', 'Vancouver, BC',  TRUE,  'Nearly new PC-12 NGX with Honeywell Primus Apex avionics. Single-engine turboprop utility with airline comfort.', '{"seats":9,"range_nm":1803,"cruise_speed":290,"avionics":"Honeywell Primus Apex"}'),
  ('Cessna',   'Citation CJ3+',2019, 6800000, 'CAD $6,800,000', 890,  890,  'light_jet', 'Calgary, AB',    TRUE,  'Citation CJ3+ with Collins Pro Line 21 avionics. Factory warranty remaining. RVSM equipped.', '{"seats":8,"range_nm":2040,"cruise_speed":416,"avionics":"Collins Pro Line 21"}');

-- Done! Your SkyLife Aircrafts database is ready.
