# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Custom AI Instructions
- **IMPORTANT LANGUAGE RULE**: ALWAYS reply and communicate with the user ONLY in the Turkmen language (Türkmen dili). Never use English or other languages for conversation unless explicitly requested to do so for a specific code snippet.

## Commands

```bash
# Run app
flutter run                        # default device
flutter run -d chrome              # web (Chrome)
flutter run --dart-define=USE_MOCK_API=false  # real backend

# Build
flutter build apk
flutter build web

# Test
flutter test                       # all tests
flutter test test/widget_test.dart # single file

# Quality
flutter analyze
flutter format lib/
flutter pub get
flutter clean
```

Physical device testing: override the API host in `lib/config.dart` via `kApiHostOverride` (local Wi-Fi IP).

## Architecture

**Parla** is a Flutter salon booking app. Entry point: `lib/main.dart` — wraps the app in `ProviderScope` (Riverpod).

### State management — Riverpod

All providers live in `lib/providers/`. Patterns used:
- `StateProvider` — simple UI state (selected tab index)
- `StateNotifierProvider` — persistent local state (favourites, recent searches, bookings) backed by `SharedPreferences`
- `FutureProvider` — async data from the API service

### API layer

`lib/services/` contains a single `ApiService`. Whether it returns mock or real data is controlled by `kUseMockApi` in `lib/config.dart` (default: `true`). Platform-specific host resolution uses conditional imports (`config_io.dart` / `config_stub.dart`).

### Navigation

No navigation package — plain `Navigator.push` with a custom `fadeSlideRoute<T>()` helper (280 ms forward / 240 ms reverse fade+slide). All screen pushes use this helper.

### Design system

Tokens live in four files — edit these before touching individual widgets:

| File | Contains |
|---|---|
| `lib/theme.dart` | `buildParlaTheme()` — Material 3, cyan primary (#00ACC1), button color (#0E7490), all `ThemeData` |
| `lib/app_text_styles.dart` | `AppTextStyles` — Plus Jakarta Sans (display) + Inter (body), 11 named styles |
| `lib/app_spacing.dart` | `AppSpacing` + `AppSizes` — spacing constants, card/header/nav dimensions |
| `lib/app_radius.dart` | `AppRadius` — s/m/card/pill/circle radii; `kStickerCardDecoration()` shadow helper |

Shadow presets (`kShadowSm`, `kShadowMd`, etc.) and the two-layer sticker card shadow are defined in `app_radius.dart`.

### Screens

Seven-step booking flow: **BookingScreen** (`lib/screens/booking_screen.dart`) drives service → staff → date/time → guest count → guest info → review → **ConfirmationScreen**.

Main shell is `BottomNavShell` (3-tab frosted-glass bar, `IndexedStack`) covering Home / My Bookings / Profile.

`SalonDetailScreen` has a sticky header with scroll-driven opacity and multiple inner tab sections (Services, Staff, Gallery, Reviews, About).

### Models

`lib/models/` — `Salon`, `Service`, `Booking`. `Booking` has computed helpers (`resolvedServiceIds`, `serviceSummary`).

### Tests

`test/widget_test.dart` uses `flutter_test` + Riverpod `ProviderScope` with `SharedPreferences.setMockInitialValues`. Tests cover scroll animations, hero transitions, sticky tabs, booking flow interactions, and favourite persistence.
