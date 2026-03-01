# 👻 Bounty Ghost — Flutter Frontend

> **Hyper-local P2P Bounty Marketplace**  
> Phase 1: Full UI with mock data. Phase 2: Live Spring Boot backend.

---

## Prerequisites

| Tool | Version |
|---|---|
| Flutter SDK | ≥ 3.22 |
| Dart SDK | ≥ 3.3 |
| Android Studio / Xcode | Latest stable |

Install Flutter: https://flutter.dev/docs/get-started/install

---

## Quick Start

```bash
cd Bounty_frontend
flutter pub get
flutter run

# Phase 2 — pass real config:
flutter run \
  --dart-define=BASE_URL=https://api.bountyghost.com/api/v1 \
  --dart-define=WS_URL=wss://api.bountyghost.com/ws \
  --dart-define=GOOGLE_MAPS_KEY=AIzaSy...
```

---

## Google Maps Setup (Required for live map tiles)

**Android** — `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data android:name="com.google.android.geo.API_KEY"
           android:value="YOUR_GOOGLE_MAPS_API_KEY"/>
```

**iOS** — `ios/Runner/AppDelegate.swift`:
```swift
GMSServices.provideAPIKey("YOUR_GOOGLE_MAPS_API_KEY")
```

> Phase 1 runs without an API key — a styled neon-grid placeholder is shown.

---

## Architecture

```
lib/
├── main.dart                       ← Entry point, DI init, app root
├── core/
│   ├── config.dart                 ← useMock, baseUrl, wsUrl, mapsKey
│   ├── di/dependency_injection.dart← GetIt service locator
│   ├── errors/failures.dart        ← Failure hierarchy (Either pattern)
│   ├── networking/api_client.dart  ← Dio (Phase 2)
│   ├── routes/                     ← GoRouter + AppRoutes constants
│   ├── shell/bounty_shell.dart     ← Persistent bottom nav
│   ├── theme/
│   │   ├── bounty_colors.dart      ← Full neon palette
│   │   └── bounty_theme.dart       ← Material 3 dark theme
│   └── usecases/usecase.dart       ← Base UseCase<T, P> interface
├── data/
│   └── mock_services/              ← PHASE 1 CORE
│       ├── i_bounty_service.dart   ← Interface (unchanged in Phase 2)
│       ├── mock_bounty_service.dart← 6 seed bounties, full CRUD
│       ├── mock_user_service.dart
│       ├── mock_wallet_service.dart
│       └── mock_models/            ← MockBounty, MockUser, MockWallet
└── features/
    ├── auth/                       ← Login / Register
    ├── map_poster/                 ← ⭐ UnifiedMapPage (core screen)
    ├── map_hunter/                 ← Hunter mode (Phase 2 stub)
    ├── errands_dashboard/          ← My Posted + Hunting tabs
    └── wallet/                     ← Balance, Deposit, Txn history
```

---

## Phase 2 Toggle

```dart
// lib/core/config.dart
static const bool useMock = false; // flip this

// lib/core/di/dependency_injection.dart
sl.registerLazySingleton<IBountyService>(
  () => RemoteBountyService(client: sl<ApiClient>()),
);
```

BLoC, domain, and UI layers are **unmodified**.

---

## Color Palette

| Token | Hex | Usage |
|---|---|---|
| `backgroundDeep` | `#050810` | Map screen root |
| `neonCyan` | `#00FFFF` | Poster mode, primary CTA |
| `neonGreen` | `#00FF00` | Hunter mode, success |
| `neonRed` | `#FF0000` | Urgent, danger |

---

## Docs
- [docs/architecture.md](docs/architecture.md) — Spring Boot microservices plan
- [docs/api_spec.md](docs/api_spec.md) — REST + WebSocket API spec