# Rates Feature

## Description

The **rates** feature is the shared FX engine for Nerkhak. It fetches indicative reference rates from **Frankfurter** for global currencies, overlays **free-market Iranian Rial (IRR)** from a **public Google Drive JSON feed** (USD→IRR only; other pairs triangulated via USD), caches snapshots locally, persists the user's selected currency list, and hosts the Home (Currency List) presentation layer. Other features depend only on this feature's **domain** layer (entities + use cases), never on its data models.

## Architecture

- `rates_di.dart` — GetIt registrations for data sources, repository, use cases, `HomeBloc`
- **Domain**
  - `entities/currency.dart` — ISO code + name
  - `entities/rate_snapshot.dart` — latest rates for a base
  - `entities/historical_series.dart` — chart time series
  - `entities/selected_currency.dart` — Home list selection + base flag
  - `repositories/rates_repository.dart` — domain contract
  - `usecases/` — `GetLatestRates`, `GetHistoricalSeries`, `GetSupportedCurrencies`, `ConvertAmount`, selection use cases, `RefreshRates`
- **Data**
  - `datasources/remote/frankfurter_remote_data_source.dart` — Frankfurter v2 HTTP (global FX)
  - `datasources/remote/iran_irr_remote_data_source.dart` — IRR feed contract
  - `datasources/remote/drive_irr_remote_data_source.dart` — Google Drive JSON (USD→IRR)
  - `datasources/local/rates_local_data_source.dart` — SharedPreferences cache
  - `utils/irr_rate_overlay.dart` — pure Frankfurter + Drive IRR merge helpers
  - `models/` — DTOs with `toDomain()`
  - `repositories/rates_repository_impl.dart` — cache-first / offline fallback + IRR overlay
- **Presentation**
  - `bloc/home_*.dart` — freezed events/states + `HomeBloc`
  - `pages/home_page.dart` — Stitch Home list UI
  - `widgets/currency_row.dart` — editable amount (normal) or remove + drag handles (edit mode)

## Use Cases

1. **Use Case:** `GetLatestRates`  
   **Description:** Loads the latest FX snapshot for a base; IRR is replaced with the newest Drive USD→IRR rate when available.  
   **Data Flow:** `HomePage -> HomeBloc -> GetLatestRates -> RatesRepository -> FrankfurterRemoteDataSource + IranIrrRemoteDataSource / RatesLocalDataSource`

2. **Use Case:** `ConvertAmount`  
   **Description:** Pure triangular conversion using a snapshot rate map.  
   **Data Flow:** `HomeBloc -> ConvertAmount` (no I/O)

3. **Use Case:** `AddSelectedCurrency` / `RemoveSelectedCurrency` / `SetBaseCurrency` / `ReorderSelectedCurrencies`  
   **Description:** Persist the Home list selection, base, and display order.  
   **Data Flow:** `HomeBloc / AddCurrencyBloc -> UseCase -> RatesRepository -> RatesLocalDataSource`

## Data Flow

1. User opens Home → `HomeEvent.started`
2. BLoC loads selected currencies + catalog + latest rates
3. Repository fetches Frankfurter, then overlays IRR from the Drive JSON feed
4. Amounts are converted locally from the snapshot
5. User taps any currency row → keyboard opens; typing dispatches `amountChanged(code, amount)`
6. BLoC realigns every other currency via `ConvertAmount` on the cached snapshot (no network)
7. Pull-to-refresh calls `RefreshRates` and updates the timestamp footer
8. Long-press a row to change the persisted base (local recalculation only)
9. Swipe a row end-to-start (or tap remove in edit mode) to remove it from the list
10. Tap the pen icon → `editModeToggled`; each card shows remove + drag handles
11. Drag a handle → `currenciesReordered` → `ReorderSelectedCurrencies` persists the new order
12. Tap the check icon to leave edit mode

## IRR source notes

- Frankfurter IRR is an official/reference-style rate and is **not** Iran’s free-market rate.
- Free-market USD→IRR comes from a public Google Drive JSON (`AppConstants.usdIrrDriveFeedUrl`).
- Template / local copy: `rates_feed/usd_irr_rates.json` (append `{ "at", "rate" }` rows when updating).
- Other currencies vs IRR are triangulated: `(foreign→USD from Frankfurter) × (USD→IRR from Drive)`.
- Synthetic **IRT** (Iranian Toman) is derived locally as `IRR / 10` (1 Toman = 10 Rial). No extra API.
- Charts for pairs involving IRR/IRT use Drive USD history (and Frankfurter cross rates for non-USD legs).

## Key Components

- Clean Architecture + feature-first
- `flutter_bloc` + `freezed`
- Dartz `Either<Failure, T>`
- Dio + Frankfurter v2 (~165 active currencies)
- Dio + Google Drive JSON (USD→IRR overlay only)
- SharedPreferences cache
- GetIt feature DI
- `SliverReorderableList` for Home list edit mode
