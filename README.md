# SkyLife Aircrafts — Public Website

**Ontario's Premier Private Aircraft Brokerage**

🌐 Live site: [skylifeaircrafts.ca](https://skylifeaircrafts.ca)

---

## Tech Stack

- **Frontend**: Plain HTML/CSS/JS — single file, no build step
- **Database**: Supabase (PostgreSQL) — listings + leads tables
- **Deployment**: Vercel (auto-deploys on every push to `main`)
- **CRM**: Lovable (private admin panel, connected to same Supabase DB)

## Files

| File | Purpose |
|------|---------|
| `index.html` | Public homepage — all sections, mobile responsive |
| `vercel.json` | Vercel deployment config |
| `schema.sql` | Supabase database schema (run once in Supabase SQL editor) |

## Deployment

Every push to `main` auto-deploys to Vercel. No build command needed.

## Database Setup

1. Go to your Supabase project → SQL Editor
2. Paste and run `schema.sql`
3. Add your Supabase URL + anon key to `index.html` when ready to go live

## Brand

- Primary: `#0a1628` (Dark Navy)
- Accent: `#3ecfb2` (Teal)
- Font: Cormorant Garamond + DM Sans
