# Mazdoor Sathi v2 — Flutter App

Skill-Based Team Hiring and Progress-Tracking Platform for Construction Labor.
Final Year Project, Department of Computer Science, University of Gujrat.

Fresh v2 build: 3 roles (Builder / Mazdoor / Admin), Firebase **email + password**
auth, 29 screens, Material Design 3 (Deep Navy `#0F2A4A` + Construction Orange
`#F97316`, light + dark), OpenStreetMap via flutter_map, Urdu speech-to-text,
photo progress, wage ledger, ratings, chat, complaints and admin moderation.

## Setup

1. Create a Firebase project, enable **Email/Password** auth, Firestore,
   Storage and Cloud Messaging.
2. Add the app configs: `google-services.json` (Android, package
   `com.mazdoorsathi.mazdoor_sathi`) and/or `GoogleService-Info.plist` (iOS).
   Without them the app still runs in **Demo mode** (Welcome screen buttons).
3. Run the v2 backend, then:

```bash
flutter pub get
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000
```

`API_BASE_URL` defaults to `http://10.0.2.2:5000` (Android emulator → host).

## Demo mode

Welcome screen → **Demo Builder / Demo Mazdoor / Demo Admin** uses the
backend test-auth bypass (`Authorization: Test demo-<role>`) so the full UI
can be demonstrated without Firebase configuration.

## Structure

`lib/` — `main.dart`, `app.dart`, `core/` (constants, theme, utils, services,
widgets), `models/`, `providers/`, `repositories/`, `routes/`, `screens/`
(splash, onboarding, auth, builder, worker, admin, jobs, teams, projects,
tracking, payments, profile, notifications, settings).
