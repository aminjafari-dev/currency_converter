# Orbit Currency Converter

Dark, modern Flutter currency converter built with **Clean Architecture**, **feature-first** folders, and **flutter_bloc**.

## Brand

**Orbit** — indicative mid-market / central-bank reference rates (Frankfurter), not bank cash rates.

## Screens

| Screen | Route | Feature |
|--------|-------|---------|
| Home – Currency List | `/home` | `features/rates` |
| Add Currency | `/addCurrency` | `features/currency_catalog` |
| Currency Detail & Chart | `/currencyDetail` | `features/currency_detail` |
| Settings | `/settings` | `features/settings` |
| Home Widget (domain-ready) | — | `features/home_widget` |

Design source: Stitch export under `stitch_export/` (HTML + screenshots).

## Stack

- Flutter + `flutter_bloc` + `freezed`
- Dartz `Either<Failure, T>`
- GetIt feature DI
- Dio → Frankfurter v1 (`api.frankfurter.dev`)
- SharedPreferences cache
- `fl_chart`, `country_flags`, `gap`, `google_fonts`
- l10n: English + Persian (`fa`) with RTL

## Run

```bash
flutter pub get
dart run build_runner build
flutter gen-l10n
# Open in IDE and run on a device/simulator (do not use CLI run per project rules)
```

## Architecture

See `.cursor/rules/` and each feature `README.md` under `lib/features/`.
