# 🏢 CondoKeep

A personal condo maintenance scheduler that keeps track of recurring tasks, sends email reminders, and creates Google Calendar events so nothing falls through the cracks.

## Features

- **22 condo-specific maintenance tasks** across 3 categories: Appliance Maintenance, Deep Cleaning, and Seasonal Prep
- **Smart scheduling** — tasks auto-generate their next occurrence when completed
- **Snooze support** — push tasks forward when life gets busy
- **Email + Google Calendar reminders** — get notified before tasks are due
- **Dark-mode dashboard** — clean UI to view, complete, and manage tasks

## Tech Stack

- **Backend:** Supabase (Postgres + Edge Functions)
- **Frontend:** React (single-file HTML, no build step)
- **Reminders:** Supabase Edge Function (Deno) + Google Calendar API

## Project Structure

```
condokeep/
├── public/
│   └── index.html          # Main dashboard (self-contained React app)
├── supabase/
│   ├── migrations/
│   │   ├── 001_create_schema.sql
│   │   └── 002_enable_rls.sql
│   ├── seed/
│   │   └── seed.sql         # Initial condo maintenance tasks
│   └── functions/
│       └── daily-reminders/
│           └── index.ts     # Edge Function for email + calendar reminders
├── .gitignore
└── README.md
```

## Setup

1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Run the migrations in order from `supabase/migrations/`
3. Run `supabase/seed/seed.sql` to populate tasks
4. Update `SUPABASE_URL` and `SUPABASE_KEY` in `public/index.html`
5. Deploy the Edge Function for automated reminders
6. Open `public/index.html` in your browser

## Configuration

Edit `user_preferences` in the database to customize:
- Email address for notifications
- Reminder lead time (default: 3 days before due)
- Google Calendar integration toggle
- Email notification toggle

## License

MIT
