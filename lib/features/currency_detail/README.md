# Currency Detail Feature

## Description

The **currency_detail** feature powers the Currency Detail & Chart screen: live rate header, conversion line, % change, lime `fl_chart` series, range chips (1D–ALL), High/Low/% stats, and an Orbit Insight card. Historical stats are computed client-side from Frankfurter series because the API does not return them.

## Architecture

- `currency_detail_di.dart` — `ComputeCurrencyStats` + `DetailBloc`
- **Domain**
  - `entities/range_option.dart` — chart range enum → date window
  - `entities/currency_stats.dart` — high/low/% from series
  - `usecases/compute_currency_stats.dart`
- **Presentation**
  - `bloc/detail_*.dart`
  - `pages/currency_detail_page.dart`

## Use Cases

1. **Use Case:** `GetLatestRates` / `GetHistoricalSeries` (rates)  
   **Description:** Live rate + chart points.  
   **Data Flow:** `CurrencyDetailPage -> DetailBloc -> UseCases -> RatesRepository`

2. **Use Case:** `ComputeCurrencyStats`  
   **Description:** Derives High / Low / % Change from the series.  
   **Data Flow:** `DetailBloc -> ComputeCurrencyStats`

## Data Flow

1. Navigate with `CurrencyDetailArgs(code, baseCode)`
2. Load latest + historical for the selected range
3. Recompute stats; update chart when range chips change
4. Insight card uses localized editorial copy (not FX API)

## Key Components

- `fl_chart` line chart with lime gradient
- Named route args via `CurrencyDetailArgs`
- BLoC + freezed + Dartz
