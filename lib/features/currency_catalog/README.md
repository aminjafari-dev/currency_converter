# Currency Catalog Feature

## Description

The **currency_catalog** feature provides the Add Currency screen: searchable catalog, Popular + alphabetical sections, TRENDING badges, and lime +/- toggles. It has no own data layer — it depends on the `rates` domain use cases for the supported catalog and selection persistence.

## Architecture

- `currency_catalog_di.dart` — registers `AddCurrencyBloc` as a factory
- **Presentation**
  - `bloc/add_currency_*.dart` — search / toggle events and load states
  - `pages/add_currency_page.dart` — Stitch Add Currency UI

## Use Cases

1. **Use Case:** `GetSupportedCurrencies` (from rates)  
   **Description:** Loads the full currency catalog.  
   **Data Flow:** `AddCurrencyPage -> AddCurrencyBloc -> GetSupportedCurrencies -> RatesRepository`

2. **Use Case:** `AddSelectedCurrency` / `RemoveSelectedCurrency` (from rates)  
   **Description:** Toggle membership in the Home list.  
   **Data Flow:** `AddCurrencyPage -> AddCurrencyBloc -> UseCase -> RatesRepository`

## Data Flow

1. Screen opens → load catalog + currently selected codes
2. User types → local filter on code/name
3. User taps +/- → add/remove via repository; UI updates check state
4. Popping back refreshes Home

## Key Components

- BLoC + freezed
- Popular / trending lists from `AppConstants`
- `CurrencyFlag` via `country_flags`
- Localization via `AppLocalizations`
