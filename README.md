# The Archivist — Student Activity Tracker

A Flutter MVP for tracking student daily activities across four key areas:
**عبادات (Ibadaat)** · **القرآن (Quran)** · **عادات (Habits)** · **دراسة (Study)**

## Design

Built with the **"Scholarly Manuscript"** design system — Islamic heritage meets modern editorial design:
- **Parchment** background (`#FCF9F0`)
- **Deep Teal** primary (`#00342B`)  
- **Muted Gold** accents (`#775A19`)
- Noto Serif headlines + Plus Jakarta Sans body
- Mihrab arch shapes, mashrabiya patterns, tonal layering (no borders)

Design mockups are in `stitch_remix_of_login_screen/`.

## Architecture

```
lib/
├── core/          # Theme, shared widgets, constants
├── features/
│   ├── auth/      # Login (local MVP, swap to Firebase)
│   └── students/  # Students CRUD + daily tracking
└── routing/       # GoRouter with auth guards
```

**Key decisions:**
- **Riverpod** for state management
- **Repository pattern** — local SharedPreferences now, Firestore later (no UI changes)
- **Feature-first** folder structure for scalability
- **GoRouter** with auth redirect guards

## Getting Started

```bash
flutter pub get
flutter run
```

## Screens

| Screen | Description |
|--------|-------------|
| Login | Email/password auth with scholarly design |
| Students List | Card grid with search, filters, class insights |
| Student Profile | Bento grid with 4 tracking sections + streak + progress |
| Add/Edit Student | Form with arch avatar, validation, tip box |

## Tracking Categories

Each student has a daily record with checkbox items in 4 categories:

- **Ibadaat**: Fajr, Morning Adhkar, Dhuhr, Asr, Maghrib, Isha, Evening Adhkar
- **Quran**: Hifz Revision, Tafsir Study, Daily Tilawah
- **Habits**: Hydration, Daily Walk, Digital Detox, Early Bedtime
- **Study**: Arabic Grammar, Islamic Studies, Mathematics

Progress is auto-computed and displayed as percentages + streaks.

## Next Steps (Post-MVP)

- [ ] Firebase Auth + Firestore backend
- [ ] Dashboard screen with aggregate analytics
- [ ] Settings screen with profile management
- [ ] Dark mode support
- [ ] Push notifications for daily reminders
- [ ] Export/print student reports
