-- ============================================================
-- SkyLife Aircrafts — Run this in Supabase SQL Editor
-- Fixes: RLS policy so frontend can read listings
-- ============================================================

-- 1. Enable RLS on listings table (safe to run even if already enabled)
ALTER TABLE listings ENABLE ROW LEVEL SECURITY;

-- 2. Drop old policy and recreate cleanly with explicit role grants
DROP POLICY IF EXISTS "Public can view active listings" ON listings;

CREATE POLICY "Public can view active listings"
  ON listings
  FOR SELECT
  TO anon, authenticated
  USING (status = 'active');

-- 3. Verify it worked — this should return your listings:
-- SELECT id, make, model, status, featured FROM listings WHERE status = 'active';
