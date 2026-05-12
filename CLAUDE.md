# SkyLife Aircrafts — Claude Code Instructions

## About This Repo
Public website for **SkyLife Aircrafts**, a private aircraft brokerage based in Willowdale, Ontario, Canada.
Owner is 18 years old, building from $0. Long-term vision: scale into airlines / private jet company.

## Tech Stack
- **Frontend**: Single HTML file (`index.html`) — no framework, no build step
- **Database**: Supabase (PostgreSQL) — `listings` + `leads` tables
- **Deployment**: Vercel — auto-deploys on every push to `main`
- **CRM**: Lovable (private) — connected to same Supabase project

## Supabase Credentials
- **Project URL**: `https://qwybhopcinfbostwnfvm.supabase.co`
- **Publishable Key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InF3eWJob3BjaW5mYm9zdHduZnZtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzg2MDcxNTcsImV4cCI6MjA5NDE4MzE1N30.DN-kzSn2SklW6pMhIQzMKjiD9zpwhg6bESFq3eFrz8s`

## Brand
- **Primary**: `#0a1628` (Dark Navy)
- **Accent**: `#3ecfb2` (Teal)
- **Fonts**: Cormorant Garamond (display) + DM Sans (body)
- **Logo**: Transparent PNG embedded as base64 in `index.html` — never remove or replace

## Database Schema
```
listings: id, make, model, year, price, total_time, category, location, specs (JSONB), featured, status
leads: id, name, email, phone, budget, message, aircraft_interest, listing_id, source, status
```

## Rules — ALWAYS FOLLOW
1. **Main file is `index.html`** — never delete, rename, or split into multiple files
2. **Never modify `vercel.json`**
3. **After EVERY change**: `git add . && git commit -m "describe change" && git push origin main`
4. **Always confirm** what was pushed after each operation
5. **Never remove the base64 logo** embedded in the `<img class="logo-img">` tag
6. **Keep Supabase credentials** in the script — they are publishable/safe for frontend use

## Workflow
When given an updated `index.html` from Claude.ai:
1. Replace the existing `index.html` with the new one
2. Run: `git add . && git commit -m "Update homepage" && git push origin main`
3. Confirm the push succeeded

## Design Principles
- Dark luxury aviation aesthetic
- Mobile-first responsive (4 breakpoints: 1024, 768, 480, 375px)
- All aircraft listings fetched live from Supabase
- Contact/inquiry forms post to Supabase `leads` table
- White header, fixed nav, transparent logo
