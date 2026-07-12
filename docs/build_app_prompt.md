# Build Prompt — Nerkhak Currency Converter (Flutter)

Copy and paste everything below the line into a coding agent (or a new chat) when you are ready to build the app.

---

## Role

You are an expert Flutter developer. Build a production-ready **currency converter** mobile app from the Stitch designs already exported in this repository. Follow Clean Architecture, feature-first organization, and `flutter_bloc` exactly as defined in the project rules / user standards. Do not invent a different architecture.

---

## Product idea (what we are building)

Build a dark, modern currency converter app branded **Nerkhak** (نرخک). Use this name consistently in UI + localization.

### Core experience

1. User sees a **home list** of selected currencies with converted amounts vs a base currency.
2. User can **add/remove** currencies from a searchable catalog (popular + alphabetical).
3. User can open a **currency detail** screen with live/indicative rate, % change, historical chart (1D / 1W / 1M / 6M / 1Y / ALL), high/low/% stats, and an insight card.
4. App supports an optional **home-screen widget** showing base currency, a few rates, trends, and last-updated time.
5. Rates are **indicative mid-market / reference rates** (not bank cash rates). Always show last-updated time.

### Non-goals (for v1)

- Real money transfers / remittance
- Trading / order books
- User accounts (unless needed later)
- Scraping websites for rates

---

## Design source of truth (Stitch → Flutter)

All UI must visually match the Stitch export. Do **not** redesign from scratch.

### Project metadata

- Stitch project title: **Flux Currency Converter**
- Stitch project ID: `6330284125708689549`

### Exported assets in this repo

Use these files as the pixel/layout reference while implementing Flutter widgets:

| Screen | Stitch screen ID | Screenshot | HTML reference |
|--------|------------------|------------|----------------|
| Home – Currency List | `22112d5480e542ea84eb5fcf2db3e1ac` | `stitch_export/images/01_home_currency_list.png` | `stitch_export/html/01_home_currency_list.html` |
| Currency Detail & Chart | `10e3e6ab0d5a4c0fbdaa44be3aad78a2` | `stitch_export/images/02_currency_detail_chart.png` | `stitch_export/html/02_currency_detail_chart.html` |
| Add Currency | `8e6bcf06abd945f2a342987d7ca590d4` | `stitch_export/images/03_add_currency.png` | `stitch_export/html/03_add_currency.html` |
| Home Widget | `9d6b52168f114ade9c6a3513eb049603` | `stitch_export/images/04_home_widget.png` | `stitch_export/html/04_home_widget.html` |

Also read:

- `docs/currency_rate_apis.md` for rate-provider strategy
- Color tokens already embedded in the Stitch HTML Tailwind config (Material-like dark + lime accents)

### Screen-by-screen product mapping

#### 1) Home – Currency List (`PageName.home` or similar)

From `01_home_currency_list`:

- Top brand title (final brand name)
- Edit affordance + lime **+** button → navigates to **Add Currency**
- Vertical list of currency rows/cards:
  - Circular flag
  - Code + full name
  - Converted amount (mono/tabular numbers)
  - Selected/base card highlighted with lime border; amount in lime
- Footer text: “Rates updated …” with refresh icon
- Bottom nav: Convert (active) | Chart/Detail entry | Settings (Settings can be placeholder in v1)

**Behavior:**

- One editable base amount (or treat first/selected currency as base — match design interaction)
- Changing amount updates all visible conversions from cached latest rates
- Pull-to-refresh / tap refresh updates rates
- Tap a currency row → **Currency Detail & Chart** for that pair/code

#### 2) Currency Detail & Chart (`PageName.currencyDetail`)

From `02_currency_detail_chart`:

- Back button, flag + code in app bar area
- “Live Rate” (indicative) value
- Large “1 USD = X EUR”-style conversion line
- Today % change with up/down color
- Chart card with lime line + tooltip point
- Range chips: `1D | 1W | 1M | 6M | 1Y | ALL` (selected chip lime filled)
- Stats row: High / Low / % Change
- “Nerkhak Insight” / insight card (v1: static/localized placeholder or simple generated copy; **not** required from FX API)

**Behavior:**

- Load latest + historical series for selected range
- Recompute high/low/% from series when API does not provide them
- Loading / error / empty states via Bloc states

#### 3) Add Currency (`PageName.addCurrency`)

From `03_add_currency`:

- Back + title “Add Currency” + decorative icon
- Search field: “Search currency or country”
- Section **POPULAR** (USD, EUR, AMD, IRR, RUB, GBP, etc.)
- Optional TRENDING badge on some items
- Alphabetical sections (A, B, …)
- Each row: flag, code, name, lime circular **+**
- Adding updates user’s selected currency list and returns/pops to Home

**Behavior:**

- Local filter on code/name/country
- Persist selected currencies
- Prevent duplicates

#### 4) Home Widget (`04_home_widget`)

From widget design:

- Brand mark + name
- Base pill (`BASE: JPY`)
- 2–3 currencies with rate + % trend (green up / red-orange down)
- “UPDATED Xm AGO” + “Details >”
- Implement with `home_widget` (or platform widgets) **after** core screens work; at minimum prepare data model + refresh use case so widget can reuse domain layer

---

## Visual / design system rules

Extract and centralize tokens from Stitch HTML into Flutter theme classes (no raw hardcoded colors in widgets).

Key direction from export:

- **Background / surface:** near-black charcoal (`#131315`, `#0e0e10`, `#1f1f21`, `#2a2a2c`)
- **Accent / primary container:** lime (`#c6f24e`, `#abd533`)
- **On-accent:** dark green (`#273500`, `#151f00`)
- **Text:** light gray/white (`#e4e2e4`, `#c8c6c8`, `#c4c9b0`)
- **Error / down trend:** soft reds (`#ffb4ab`, `#93000a`, and down-trend accent from widget)
- **Typography:** clean sans for UI; mono/tabular for rates (JetBrains Mono or equivalent in Flutter)
- **Shape:** rounded cards, circular FABs/icon buttons, pill chips
- **Spacing:** follow Stitch spacing scale (xs 8, sm 12, md 16, lg 24, xl 32, container margin 20)

Shared UI kit required by project standards:

- `GScaffold`, `GText`, `GButton`, `GGap` (Gap package wrappers)
- `ImagePath` for all asset paths
- Theme via `app_theme` (or equivalent) — never use ad-hoc `Color(0xFF...)` in feature widgets

All user-visible strings via Flutter localization (ARB), including English (and prepare structure for FA/RTL if required by standards).

---

## Navigation (named routes only)

Register in `core/router/page_name.dart` + `page_router.dart`:

Suggested routes:

- `PageName.home` → Home Currency List
- `PageName.addCurrency` → Add Currency
- `PageName.currencyDetail` → Detail & Chart (pass currency code / pair args)
- (Optional later) `PageName.settings`

Rules:

- No anonymous `MaterialPageRoute`
- No hardcoded `"/..."` strings outside `PageName`
- Navigate with `Navigator.of(context).pushNamed(PageName....)`

---

## Architecture requirements

Strict Clean Architecture + feature-first:

```
lib/
  core/          # theme, widgets (G*), router, error, network, locator, utils, l10n
  features/
    rates/ or converter/
      data/
        datasources/   # remote + local
        models/
        repositories/
      domain/
        entities/
        repositories/  # interfaces
        usecases/
      presentation/
        bloc/
        pages/
        widgets/
    currencies/        # catalog / add currency (if split)
    widget/            # home widget bridge (optional feature)
```

### State management

- `flutter_bloc` + `freezed` events/states
- Sealed events; operation states with `initial/loading/completed/error`
- Use cases return `Either<Failure, T>` (Dartz) or project `DataSuccess`/`DataFailed` pattern already standardized in rules — be consistent with repo standards
- Register dependencies with GetIt; feature DI files + root `locator.dart`
- No `BuildContext` inside Bloc

### Suggested domain use cases

- `GetLatestRates`
- `GetHistoricalRates` (range)
- `ConvertAmount`
- `GetSupportedCurrencies`
- `WatchSelectedCurrencies` / `AddCurrency` / `RemoveCurrency`
- `RefreshRates` (for pull-to-refresh + widget)

### Data / rates strategy (v1)

Implement provider behind a repository interface so it is swappable.

**Default v1 recommendation:**

- Primary remote: **Frankfurter** (free, latest + historical) — see `docs/currency_rate_apis.md`
- Local cache: persist last successful snapshot + timestamp
- Convert offline from cache between refreshes
- Compute high/low/% change from historical points
- Later upgrade path: ExchangeRate-API / Fixer without rewriting presentation

Never call network on every keystroke; debounce amount input; cache aggressively.

---

## Implementation order (follow this)

1. **Core foundation:** theme tokens from Stitch, `GScaffold`/`GText`/`GButton`/`GGap`, `ImagePath`, l10n, router, locator, failures, network client
2. **Domain + data for rates & currency catalog** (entities, use cases, Frankfurter datasource, cache)
3. **Home page UI** matching `01_home_currency_list` + Bloc wiring
4. **Add Currency page** matching `03_add_currency` + persistence of selection
5. **Detail & Chart page** matching `02_currency_detail_chart` + historical Bloc
6. **Bottom navigation** connecting Home ↔ Detail entry ↔ Settings placeholder
7. **Home widget** data + UI approximation of `04_home_widget` (platform widget if feasible)
8. **Polish:** loading/error/empty, pull-to-refresh, last-updated copy, rounding per currency (e.g. JPY 0 decimals)

---

## Quality bar

- Match Stitch screens closely (spacing, hierarchy, lime accents, dark surfaces)
- Feature-first Clean Architecture only
- Comments before classes/functions explaining usage + short example (per project rule)
- Localization for every string
- No custom colors outside theme
- Unit tests for use cases / repository mapping at minimum
- Keep functions focused; prefer const widgets

---

## Explicit instructions to the coding agent

1. Read the PNG + HTML under `stitch_export/` before building each page.
2. Read `docs/currency_rate_apis.md` before implementing the rates datasource.
3. Prefer implementing reusable widgets that mirror Stitch components (currency row, search field, chart range chips, bottom nav).
4. Unify branding to one name across screens/widget.
5. Do not invent extra marketing sections beyond the Stitch screens.
6. When unsure about a visual detail, trust the screenshot over assumption.
7. Ask before introducing paid APIs or backend infra; default to Frankfurter + local cache for v1.

---

## Acceptance criteria

- [ ] App launches to Home list styled like `01_home_currency_list.png`
- [ ] User can open Add Currency and add/remove currencies like `03_add_currency.png`
- [ ] User can open Detail & Chart with ranges and stats like `02_currency_detail_chart.png`
- [ ] Amounts convert using cached latest rates; timestamp visible
- [ ] Named routes only; Clean Architecture layers respected
- [ ] Theme/tokens centralized; strings localized
- [ ] Rates provider behind repository (Frankfurter v2)
- [ ] Widget design either implemented or domain-ready with clear next step

---

**Start now by scaffolding core theme/router/l10n from the Stitch tokens, then implement the Home feature end-to-end against the exported screenshot.**
