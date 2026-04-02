# The Archivist — Student Activity Tracker

A Flutter app for tracking student daily activities across four key areas:
**عبادات (Ibadaat)** · **القرآن (Quran)** · **عادات (Habits)** · **دراسة (Study)**

## Backend: Supabase

This app uses **Supabase** for authentication and database:
- **Auth**: Email/password signup & login via Supabase Auth
- **Database**: PostgreSQL with Row Level Security (each user only sees their own students)
- **Real-time ready**: Architecture supports Supabase real-time subscriptions

### Setup

1. Create a project at [supabase.com](https://supabase.com)
2. Run the SQL schema in `supabase/schema.sql` via the SQL Editor
3. Enable **Email** auth in Authentication → Providers
4. Copy your project URL and anon key from Settings → API

### Running

```bash
flutter pub get
flutter run \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=your-anon-key
```

Or edit `lib/core/config/supabase_config.dart` directly for development.

## Design

Built with the **"Scholarly Manuscript"** design system — Islamic heritage meets modern editorial:
- **Parchment** background (`#FCF9F0`)
- **Deep Teal** primary (`#00342B`)
- **Muted Gold** accents (`#775A19`)
- Noto Serif headlines + Plus Jakarta Sans body
- Mihrab arch shapes, mashrabiya patterns, tonal layering (no borders)

Design mockups are in `stitch_remix_of_login_screen/`.

## Architecture

```
lib/
├── core/          # Theme, shared widgets, constants, config
├── features/
│   ├── auth/      # Supabase Auth (login, signup, logout)
│   └── students/  # Students CRUD + daily tracking
└── routing/       # GoRouter with auth guards
```

**Key decisions:**
- **Riverpod** for state management
- **Repository pattern** — `SupabaseStudentRepository` implements the abstract interface
- **Feature-first** folder structure for scalability
- **GoRouter** with Supabase auth stream redirect guards
- **RLS** (Row Level Security) — data is scoped per user at the database level

## Screens

| Screen | Description |
|--------|-------------|
| Login | Email/password auth with signup toggle |
| Students List | Card grid with search, filters, class insights, logout |
| Student Profile | Bento grid with 4 tracking sections + streak + progress |
| Add/Edit Student | Form with arch avatar, validation, delete option |

## Tracking Categories

Each student has a daily record with checkbox items in 4 categories:

- **Ibadaat**: Fajr, Morning Adhkar, Dhuhr, Asr, Maghrib, Isha, Evening Adhkar
- **Quran**: Hifz Revision, Tafsir Study, Daily Tilawah
- **Habits**: Hydration, Daily Walk, Digital Detox, Early Bedtime
- **Study**: Arabic Grammar, Islamic Studies, Mathematics

Progress is auto-computed and displayed as percentages + streaks.

## Database Schema

See `supabase/schema.sql` for the full schema with RLS policies.

| Table | Description |
|-------|-------------|
| `students` | Student profiles, scoped by `user_id` |
| `daily_records` | Daily tracking data, linked via `student_id` FK |

## Next Steps

- [ ] Dashboard screen with aggregate analytics
- [ ] Settings screen with profile management
- [ ] Dark mode support
- [ ] Push notifications for daily reminders
- [ ] Supabase real-time subscriptions for live updates
- [ ] Export/print student reports
