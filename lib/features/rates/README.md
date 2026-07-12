# Rates Feature

## Description

The **rates** feature is the shared FX engine for Orbit. It fetches indicative reference rates from **Frankfurter** for global currencies, overlays **free-market Iranian Rial (IRR)** from the **Oanor Iran Rial Market API**, caches snapshots locally, persists the user's selected currency list, and hosts the Home (Currency List) presentation layer. Other features depend only on this feature's **domain** layer (entities + use cases), never on its data models.

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
  - `datasources/remote/oanor_irr_remote_data_source.dart` — Oanor irr-api (bazaar IRR only)
  - `datasources/local/rates_local_data_source.dart` — SharedPreferences cache
  - `utils/irr_rate_overlay.dart` — pure Frankfurter + Oanor merge helpers
  - `models/` — DTOs with `toDomain()`
  - `repositories/rates_repository_impl.dart` — cache-first / offline fallback + IRR overlay
- **Presentation**
  - `bloc/home_*.dart` — freezed events/states + `HomeBloc`
  - `pages/home_page.dart` — Stitch Home list UI
  - `widgets/currency_row.dart` — editable amount (normal) or remove + drag handles (edit mode)

## Use Cases

1. **Use Case:** `GetLatestRates`  
   **Description:** Loads the latest FX snapshot for a base; IRR is replaced with Oanor bazaar rate when available.  
   **Data Flow:** `HomePage -> HomeBloc -> GetLatestRates -> RatesRepository -> FrankfurterRemoteDataSource + OanorIrrRemoteDataSource / RatesLocalDataSource`

2. **Use Case:** `ConvertAmount`  
   **Description:** Pure triangular conversion using a snapshot rate map.  
   **Data Flow:** `HomeBloc -> ConvertAmount` (no I/O)

3. **Use Case:** `AddSelectedCurrency` / `RemoveSelectedCurrency` / `SetBaseCurrency` / `ReorderSelectedCurrencies`  
   **Description:** Persist the Home list selection, base, and display order.  
   **Data Flow:** `HomeBloc / AddCurrencyBloc -> UseCase -> RatesRepository -> RatesLocalDataSource`

## Data Flow

1. User opens Home → `HomeEvent.started`
2. BLoC loads selected currencies + catalog + latest rates
3. Repository fetches Frankfurter, then overlays IRR from Oanor (`/v1/currencies`)
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
- Oanor exposes bazaar prices (TGJU-backed) in IRR (and toman).
- If Oanor returns `subscription_required` (key not subscribed on the marketplace), the app falls back to **TGJU** (same free-market source) so IRR is never left on Frankfurter’s ~1.37M rate.
- Charts for pairs involving IRR use Oanor `/v1/history` when possible; otherwise TGJU history for the same foreign codes.
- API key: `AppConstants.oanorApiKey` (override with `--dart-define=OANOR_API_KEY=…`). Subscribe the key to **Iran Rial Market API** on [oanor.com](https://www.oanor.com/api/irr-api) (click **Subscribe** on the Free plan).

## Key Components

- Clean Architecture + feature-first
- `flutter_bloc` + `freezed`
- Dartz `Either<Failure, T>`
- Dio + Frankfurter v2 (~165 active currencies)
- Dio + Oanor irr-api (IRR overlay only)
- SharedPreferences cache
- GetIt feature DI
- `SliverReorderableList` for Home list edit mode
