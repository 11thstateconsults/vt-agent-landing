-- ============================================
-- Virtual Twins: Affiliate Applications Table
-- Run this in Supabase Dashboard > SQL Editor
-- Project: lesmihjdpquymwwilsuv
-- ============================================

-- Create the table
CREATE TABLE IF NOT EXISTS public.affiliate_applications (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  email TEXT NOT NULL,
  phone TEXT NOT NULL,
  audience_size TEXT NOT NULL,
  audience_description TEXT NOT NULL,
  promotion_plan TEXT NOT NULL,
  website_url TEXT,
  status TEXT DEFAULT 'pending',
  utm_source TEXT,
  utm_medium TEXT,
  utm_campaign TEXT,
  utm_content TEXT,
  utm_term TEXT,
  landing_url TEXT,
  user_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE public.affiliate_applications ENABLE ROW LEVEL SECURITY;

-- Allow anonymous inserts (same pattern as landing_leads)
CREATE POLICY "Allow anonymous inserts" ON public.affiliate_applications
  FOR INSERT
  TO anon
  WITH CHECK (true);

-- Allow service role full access
CREATE POLICY "Service role full access" ON public.affiliate_applications
  FOR ALL
  TO service_role
  USING (true)
  WITH CHECK (true);

-- Auto-update timestamp trigger (reuse if exists, create if not)
CREATE OR REPLACE FUNCTION public.update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS set_updated_at ON public.affiliate_applications;
CREATE TRIGGER set_updated_at
  BEFORE UPDATE ON public.affiliate_applications
  FOR EACH ROW
  EXECUTE FUNCTION public.update_updated_at();

-- Index on email for duplicate checking
CREATE INDEX IF NOT EXISTS idx_affiliate_applications_email ON public.affiliate_applications(email);

-- Index on status for filtering
CREATE INDEX IF NOT EXISTS idx_affiliate_applications_status ON public.affiliate_applications(status);
