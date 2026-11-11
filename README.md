# Mazdoor Sathi — v2 (Fresh Build)

**Skill-Based Team Hiring and Progress-Tracking Platform for Construction Labor**

Final Year Project — Department of Computer Science, University of Gujrat
Student: Muhammad Zayan Nadeem (23821519-001, BSCS-VII-A (M)) · Supervisor: Ms Ayesha Rashid

A complete platform connecting builders/homeowners with skilled construction
workers (mazdoors) in Pakistan: skill-based matching, team hiring, OpenStreetMap
locations, photo progress tracking, a transparent digital wage ledger, ratings,
Urdu voice input, and an admin panel.

## Structure

| Part | Folder | Stack |
|---|---|---|
| Mobile app | `app/` | Flutter / Dart, Material Design 3, Provider |
| Backend | `backend/` | Node.js / Express REST API, Firebase Admin |
| Database | Firestore | Collections in `docs/DATABASE.md`, rules in `backend/firestore.rules` |
| Docs | `docs/` | SRS, DATABASE, API, ARCHITECTURE |

## Quick start

Backend (demo/test mode, no Firebase credentials needed):
```bash
cd backend && npm install
FIRESTORE_FAKE=true ALLOW_TEST_AUTH=true npm run seed   # demo data
FIRESTORE_FAKE=true ALLOW_TEST_AUTH=true npm start      # http://localhost:5000
npm test                                                # 36 tests
```

App:
```bash
cd app && ~/flutter-sdk/bin/flutter pub get   # or your flutter install
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5000
```
Without Firebase config the app runs in **Demo mode** (Welcome screen:
Demo Builder / Demo Mazdoor / Demo Admin). To enable real email auth, FCM and
Storage, add your Firebase app config (`google-services.json` /
`firebase_options.dart`) — see `app/README.md`. Backend production setup and
Vercel deployment: see `backend/README.md`.

## Roles
- **Builder/Homeowner** — post jobs, search & match workers, hire teams, track progress, wage ledger, rate workers.
- **Mazdoor/Worker** — profile with trades/skills/wage, receive & accept/reject invites, photo progress, earnings, rate builders.
- **Admin** — dashboard stats, verify/suspend users, moderate jobs, resolve complaints.

## Verified (2026-11-11)
- Backend: 36/36 tests pass (in-memory Firestore), 40 endpoints, `node --check` clean on all files.
- Flutter: `flutter analyze` — 0 errors, 0 warnings (8 info-level lints); `flutter test` passes.
- Not yet done: Firebase config files for v2, real-device APK build, production deployment (v1 stays live as backup).
