# Rates Feature

## Description

The **rates** feature is the shared FX engine for Orbit. It fetches indicative reference rates from Frankfurter, caches them locally, persists the user's selected currency list, and hosts the Home (Currency List) presentation layer. Other features depend only on this feature's **domain** layer (entities + use cases), never on its data models.

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
  - `datasources/remote/frankfurter_remote_data_source.dart` — Frankfurter v1 HTTP
  - `datasources/local/rates_local_data_source.dart` — SharedPreferences cache
  - `models/` — DTOs with `toDomain()`
  - `repositories/rates_repository_impl.dart` — cache-first / offline fallback
- **Presentation**
  - `bloc/home_*.dart` — freezed events/states + `HomeBloc`
  - `pages/home_page.dart` — Stitch Home list UI
  - `widgets/currency_row.dart` — editable base row + converted rows

## Use Cases

1. **Use Case:** `GetLatestRates`  
   **Description:** Loads the latest FX snapshot for a base.  
   **Data Flow:** `HomePage -> HomeBloc -> GetLatestRates -> RatesRepository -> FrankfurterRemoteDataSource / RatesLocalDataSource`

2. **Use Case:** `ConvertAmount`  
   **Description:** Pure triangular conversion using a snapshot rate map.  
   **Data Flow:** `HomeBloc -> ConvertAmount` (no I/O)

3. **Use Case:** `AddSelectedCurrency` / `RemoveSelectedCurrency` / `SetBaseCurrency`  
   **Description:** Persist the Home list selection.  
   **Data Flow:** `HomeBloc / AddCurrencyBloc -> UseCase -> RatesRepository -> RatesLocalDataSource`

## Data Flow

1. User opens Home → `HomeEvent.started`
2. BLoC loads selected currencies + catalog + latest rates
3. Amounts are converted locally from the snapshot
4. Pull-to-refresh calls `RefreshRates` and updates the timestamp footer
5. Long-press a row to change the base; tap navigates to Detail

## Key Components

- Clean Architecture + feature-first
- `flutter_bloc` + `freezed`
- Dartz `Either<Failure, T>`
- Dio + Frankfurter v1
- SharedPreferences cache
- GetIt feature DI
