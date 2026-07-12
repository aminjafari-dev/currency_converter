# Currency Rate APIs — Complete Guide for Flux / Kinetic / Orbit

This document lists **all practical ways** to get currency exchange rates for a Flutter currency converter app (list, detail + chart, add currency, home widget). It covers free and paid options, what “accurate” means, and how to choose a provider for this project.

---

## 1. What “accurate” rate means

There is no single universal “correct” FX rate. Providers publish different kinds of numbers:

| Rate type | Meaning | Best for |
|-----------|---------|----------|
| **Central bank / official reference** | Daily midpoint published by ECB, Fed, etc. | Display, accounting, education |
| **Mid-market (indicative)** | Average of bid/ask across many sources | Most consumer converter apps |
| **Bank / card / remittance rate** | Mid-market ± spread + fees | What users actually pay when sending/spending money |
| **Live forex (bid/ask)** | Near real-time market quotes | Trading, pro fintech |

**For Flux-style UI:** mid-market or central-bank reference rates are enough.  
**Important:** no free (and almost no retail) API will match the exact rate a user’s bank charges.

Always show:

- Source (or “indicative mid-market”)
- Last updated time (your designs already show “Rates updated 2 min ago”)

---

## 2. Features your UI needs from an API

From the Stitch screens, plan for:

| Feature | Screen | API capability needed |
|---------|--------|------------------------|
| Convert many currencies vs one base | Home list, Widget | Latest rates for N currencies, any base |
| Live / recent rate | Detail header | Frequent refresh (hourly → 60s) |
| Chart (1D, 1W, 1M, 6M, 1Y, ALL) | Detail | Historical / time-series |
| High / Low / % change | Detail, Widget | Historical + compute, or stats endpoints |
| Search / list all currencies | Add Currency | Supported symbols list |
| Offline / widget refresh | Widget, Home | Caching + background fetch |

---

## 3. Architecture patterns (how you “add” an API)

You can integrate rates in several architectural ways. These are independent of which vendor you pick.

### 3.1 Direct client → third-party API

- Flutter app calls the FX API with an API key.
- **Pros:** Simple, fast to ship.
- **Cons:** API key can be extracted from the app; rate limits per device; harder to swap providers.

**Use when:** MVP, low risk, free-tier experiments.

### 3.2 Your backend / BFF (recommended for production)

- Flutter → your server (Firebase Functions, Cloud Run, Supabase Edge, Nest, etc.) → FX provider.
- Server holds the secret key, caches responses, aggregates history.
- **Pros:** Secure keys, one cache for all users, easy provider switch, lower vendor bill.
- **Cons:** You operate a backend.

**Use when:** App Store release, paid APIs, widgets with many users.

### 3.3 Local cache + scheduled refresh

- Fetch once (daily / hourly), store in Hive / SQLite / SharedPreferences / Isar.
- Convert offline between refreshes.
- **Pros:** Works offline; free tiers last longer; widgets stay cheap.
- **Cons:** Rates are not second-by-second “live”.

**Use when:** Always — combine with 3.1 or 3.2.

### 3.4 Multi-provider fallback

- Primary API fails → secondary (e.g. ExchangeRate-API → Frankfurter).
- **Pros:** Resilience.
- **Cons:** Slightly different numbers between sources; normalize carefully.

### 3.5 Self-hosted open-source rate server

- Run Frankfurter (or similar) yourself; ingest central-bank datasets.
- **Pros:** No vendor lock-in, no per-request bill, full control.
- **Cons:** Ops work; usually daily (not live) data.

### 3.6 Manual / static rates (not recommended for production)

- Ship a JSON file of rates, update via app release or remote config.
- **Pros:** Zero API cost.
- **Cons:** Stale; bad UX for a converter.

### 3.7 Scraping websites (not recommended)

- Scrape Google Finance, XE.com, bank pages.
- **Pros:** Seems free.
- **Cons:** Fragile, often against ToS, can break anytime, App Store risk.

---

## 4. Free options (detailed)

### 4.1 Frankfurter (best fully free starting point)

| | |
|--|--|
| **URL** | [https://frankfurter.dev](https://frankfurter.dev) |
| **Cost** | Free, no API key |
| **Data** | 84 central banks / official sources, **201 currencies** (165 active + 36 archived), history back to 1948 |
| **Update** | Typically **daily** reference rates (blended by default; filter with `providers`) |
| **Limits** | Abuse rate limits; no monthly cap |
| **Commercial** | Generally allowed (check underlying provider terms) |
| **Self-host** | Yes (open source) |

> **v1 vs v2:** Orbit uses **v2**. v1 is ECB-only (~30 codes) and omits IRR, AMD, OMR, etc. The website currency catalog documents the v2 dataset.

**Good for:** MVP, charts (historical), offline cache, learning Clean Architecture plumbing, broad ISO coverage (IRR/AMD/OMR/YER…).  
**Weak for:** “Live rate every 60 seconds”, second-level trading accuracy.

**Endpoints you care about (v2):**

- Latest rates: `GET /v2/rates?base=&quotes=`
- Historical / time series: `GET /v2/rates?base=&quotes=&from=&to=`
- Single pair: `GET /v2/rate/{base}/{quote}`
- Currency list: `GET /v2/currencies` (`scope=all` includes archived)

---

### 4.2 European Central Bank (ECB) — official feed

| | |
|--|--|
| **Source** | ECB reference rates (often EUR-based) |
| **Cost** | Free |
| **Update** | Daily (business days) |
| **Accuracy** | High as **official EUR reference** |

Frankfurter and many APIs wrap ECB data.  
You can also parse ECB XML/CSV yourself if you want zero third-party dependency.

**Good for:** EU focus, “official rate” messaging.  
**Weak for:** Huge exotic currency coverage, live FX.

---

### 4.3 ExchangeRate-API — free tier

| | |
|--|--|
| **URL** | [https://www.exchangerate-api.com](https://www.exchangerate-api.com) |
| **Cost** | Free tier (~**1,500 requests/month** typical) |
| **Update** | Free: ~**once per day**; paid: hourly |
| **Data** | ~165 currencies, multi-source blended midpoints |
| **Key** | Required |

**Good for:** Small production apps with aggressive caching.  
**Tip:** One request for all rates vs base → cache all day → thousands of conversions for free.

---

### 4.4 Fixer.io — free tier

| | |
|--|--|
| **URL** | [https://fixer.io](https://fixer.io) |
| **Cost** | Free tier (~**100 calls/month** — very limited) |
| **Update** | Better on paid plans (down to ~60 seconds) |
| **Data** | ~170 currencies, historical back to 1999 on eligible plans |

**Good for:** Trying the API shape.  
**Weak for:** Real traffic on free tier.

---

### 4.5 Open Exchange Rates — free / freemium

| | |
|--|--|
| **URL** | [https://openexchangerates.org](https://openexchangerates.org) |
| **Model** | App ID; free tier with constraints (often USD base on free) |
| **Data** | Mid-market, historical on higher plans |

**Good for:** Simple JSON, popular in tutorials.  
**Watch:** Free plan base-currency and request limits.

---

### 4.6 FreeCurrencyAPI / CurrencyAPI / similar freemium

Examples in this family:

- FreeCurrencyAPI
- CurrencyAPI
- CurrencyFreaks (free tier)
- UniRateAPI (sometimes includes crypto/metals)
- AllRatesToday (freemium)

| Typical free traits | |
|---------------------|--|
| Requests | Hundreds → thousands per month |
| Update | Daily or hourly |
| Signup | API key required |

**Good for:** Quick experiments.  
**Watch:** ToS for commercial apps, uptime, and how “live” the free plan really is.

---

### 4.7 exchangerate.host / related community APIs

Community/freemium FX APIs that often mirror Fixer-like endpoints. Quality and longevity vary — treat as secondary or fallback, not the only long-term dependency.

---

### 4.8 National banks & open government datasets

Examples:

- Federal Reserve (H.10 / related FX series)
- Bank of England
- Other central bank statistical downloads
- IMF data portals

| | |
|--|--|
| **Cost** | Free |
| **Accuracy** | High as published reference |
| **Effort** | Higher (normalize formats, schedules, missing pairs) |

**Good for:** Compliance / “official” storytelling.  
**Weak for:** Fast mobile UX without a normalizing backend.

---

### 4.9 Alpha Vantage / Twelve Data free tiers (broader market data)

These are **market data** APIs that include FX among stocks/crypto.

| | |
|--|--|
| **Cost** | Free tiers with strict rate limits |
| **FX** | Available, but not always the simplest currency-converter DX |
| **Charts** | Often strong for time series |

**Good for:** If you later add stocks/crypto.  
**Weak for:** Simple “160 fiat currencies” converter as the only goal.

---

### 4.10 What free options cannot honestly promise

- Bank cash rate / Visa-Mastercard settlement rate
- Guaranteed sub-minute accuracy for free forever
- Unlimited commercial SLA
- Perfect match across all exotic currencies at high frequency

---

## 5. Paid options (detailed)

### 5.1 Mid-tier SaaS (best fit for most mobile apps)

#### ExchangeRate-API Pro

- Hourly updates, higher quotas, strong uptime claims
- Multi-source blending (they require multiple sources per currency)
- Indicative midpoints — good for converters and e-commerce estimates
- Paid plans often start around the low tens of USD/month

#### Fixer (paid)

- Real-time-ish updates on higher plans (e.g. ~60 seconds)
- Historical + convert + time-series style endpoints
- Plans scale by monthly calls and features (base currencies, etc.)

#### Open Exchange Rates (paid)

- Unlock non-USD base, more requests, historical
- Simple, widely documented

#### CurrencyLayer

- Similar freemium → paid FX JSON API
- Live + historical patterns familiar to many Flutter tutorials

#### CurrencyFreaks / UniRateAPI (paid)

- Fiat plus sometimes crypto / metals
- Useful if Orbit later expands beyond fiat

#### Abstract API / similar “currency” products

- Developer-friendly HTTP APIs with conversion helpers
- Evaluate freshness, symbol coverage, and SLA before committing

**Why pay at this tier:**

- Hourly or faster refresh for “Live Rate” / widget copy
- Higher request ceilings
- Better historical for charts
- Email support / reliability

---

### 5.2 Business / brand FX data

#### XE Currency Data API

- Well-known brand; commercial licensing
- Used when you want trusted “XE-like” rates in a product

#### OANDA Exchange Rates API

- Business-oriented FX rates
- Strong for companies that need documented commercial terms

#### CurrencyCloud / Wise Platform (and similar)

- Oriented around **moving money**, not only displaying rates
- Rates closer to real transfer quotes (still product-specific)
- Heavier compliance and partnership process

**Use when:** You build remittance, payouts, or “guaranteed convert” — not a simple display converter.

---

### 5.3 Institutional / trading-grade

| Provider | Notes |
|----------|--------|
| **Bloomberg** | Enterprise terminals / data licenses — expensive |
| **Refinitiv (LSEG)** | Institutional market data |
| **Interactive Brokers / broker feeds** | Trading context |
| **Polygon / professional market data** | FX as one asset class among many |

**Use when:** You need bid/ask, streaming, or regulatory-grade market data.  
**Overkill for:** A consumer list + chart converter like Flux.

---

### 5.4 Aggregators & “finance API” platforms

Some platforms sell one key for stocks + FX + crypto:

- Twelve Data
- Polygon.io
- Finnhub
- Tiingo
- Marketstack (more equities-focused; check FX support)

**Pros:** One vendor if the app grows.  
**Cons:** Pricing and FX coverage may be worse than a dedicated FX API for a pure converter.

---

## 6. Comparison matrix (practical)

| Provider | Free? | Typical freshness | History/charts | Best role |
|----------|-------|-------------------|----------------|-----------|
| **Frankfurter** | Yes (full) | Daily | Excellent | MVP + charts + self-host |
| **ECB direct** | Yes | Daily | Good (EUR-centric) | Official EUR reference |
| **ExchangeRate-API** | Freemium | Daily → hourly | Good on paid | Default production path |
| **Fixer** | Tiny free | Up to ~60s on paid | Strong | Live-feeling detail screen |
| **Open Exchange Rates** | Freemium | Plan-based | Paid unlock | Simple App ID integration |
| **CurrencyFreaks / UniRate** | Freemium | Plan-based | Varies | Fiat + extras |
| **XE / OANDA** | Mostly paid | High | Commercial | Brand / business trust |
| **Bloomberg / Refinitiv** | Paid enterprise | Streaming | Full | Trading / institutional |
| **Scraping** | “Free” | Unknown | Fragile | Avoid |

---

## 7. Recommended strategies for this app

### Strategy A — Launch free (recommended first)

1. **Frankfurter** for latest + historical charts  
2. Cache rates locally (e.g. refresh every 6–24 hours)  
3. Compute % change / high / low from historical series  
4. Show “Updated …” from cache timestamp  

**Matches:** Home list, Add Currency, basic Detail chart, Widget (with less “live” wording).

### Strategy B — Freemium hybrid

1. Primary: **ExchangeRate-API** free/pro for latest  
2. Charts: Frankfurter historical (or paid historical)  
3. Backend cache so all users share one upstream request  

**Matches:** Better “updated 2 min ago” if you refresh hourly on Pro.

### Strategy C — Polished live UX

1. Paid **Fixer** / **ExchangeRate-API Pro** / **Open Exchange Rates**  
2. Server-side cache (e.g. 1–5 minutes)  
3. Widget Timeline / WorkManager refresh  
4. Keep “indicative” disclaimer  

**Matches:** “Live Rate” label on Detail screen.

### Strategy D — Enterprise later

Only if you add transfers, guaranteed quotes, or B2B white-label:

- XE / OANDA / CurrencyCloud-class providers  
- Legal review of redistributing rates  

---

## 8. How to add an API in a Clean Architecture Flutter app

Conceptual layers (no vendor lock-in):

```
Presentation (Bloc)
    → Domain UseCase (GetLatestRates, GetHistoricalRates, ConvertAmount)
        → Repository interface
            → Remote DataSource (HTTP provider A/B)
            → Local DataSource (cache)
```

### Checklist when adding any provider

1. **Create domain entities** — `Currency`, `ExchangeRate`, `RateSnapshot`, `HistoricalPoint`  
2. **Define repository interface** in domain — never import Dio/http there  
3. **Implement data models + DTO mapping** in data layer  
4. **Register in feature DI** (`currency_di.dart` → `locator.dart`)  
5. **Cache policy** — TTL, stale-while-revalidate, last-success fallback  
6. **Error mapping** — network / server / cache → `Failure` (Dartz `Either`)  
7. **Localization** — error strings via ARB, never hardcoded in UI  
8. **Security** — prefer backend proxy for paid keys  
9. **Observability** — log provider name + timestamp for debugging wrong rates  

### Caching rules of thumb

| UI | Suggested freshness |
|----|---------------------|
| Home list | 15 min – 24 h |
| Detail “live” | 1–5 min (paid) or hourly |
| Chart 1D | 5–15 min |
| Chart 1M+ | Daily is fine |
| Widget | 15–60 min (respect OS limits) |

One upstream “latest” call per TTL can feed **all** conversions for every currency pair (triangular via base).

---

## 9. Accuracy & product honesty guidelines

1. Label rates as **indicative** unless you have a licensed settlement feed.  
2. Never claim “exact bank rate” with a mid-market API.  
3. Prefer multi-source blended providers for display stability.  
4. For charts, use the **same provider** for latest and history when possible (avoids jumps).  
5. Document timezone of “daily” rates (often 14:15 CET for ECB-style data).  
6. Prefer **Frankfurter v2** for broad ISO coverage (IRR, AMD, OMR, YER, …). v1 is ECB-only and will look “incomplete” next to the website catalog.  
7. Rounding: define decimal rules per currency (JPY = 0 decimals, etc.).  

---

## 10. Cost control tips

- Cache aggressively; convert locally.  
- Fetch **all symbols in one request**, not per pair.  
- Share cache via backend for many installs.  
- Don’t poll every keystroke.  
- Widget: batch refresh; avoid per-minute paid calls.  
- Monitor monthly request counters before App Store growth.  

---

## 11. Legal / ToS reminders

- Read each provider’s **commercial use** and **redistribution** terms.  
- Some free plans ban production or require attribution.  
- Storing and re-serving rates via your API may need a paid license.  
- Scraping is the highest legal/ToS risk — avoid.  

---

## 12. Quick decision tree

```
Need only display + charts, zero budget?
  → Frankfurter (+ local cache)

Need simple production API key + daily rates?
  → ExchangeRate-API free + cache

Need “live” header / frequent widget updates?
  → ExchangeRate-API Pro or Fixer paid + 1–5 min server cache

Need bank-like transfer quotes?
  → Wise/CurrencyCloud-class (not a simple FX JSON API)

Need institutional streaming?
  → Bloomberg / Refinitiv (enterprise)
```

---

## 13. Provider shortlist for Flux

| Priority | Provider | Role |
|----------|----------|------|
| 1 | **Frankfurter** | Free latest + history for MVP |
| 2 | **ExchangeRate-API** | Easy upgrade path free → Pro |
| 3 | **Fixer** | If you specifically want sub-minute paid updates |
| 4 | **Open Exchange Rates** | Alternative mid-tier |
| Later | **XE / OANDA** | Brand / commercial licensing |
| Avoid | Scraping | Fragile and risky |

---

## 14. Mapping to your Stitch screens

| Screen | Minimum API needs | Nice-to-have |
|--------|-------------------|--------------|
| **Home – Currency List** | Latest rates for selected list vs base | Soft refresh timestamp |
| **Currency Detail & Chart** | Latest + historical series | High/low/% , insight text (separate content API) |
| **Add Currency** | Full symbol metadata (code, name) | Popular / trending flags (your own logic) |
| **Home Widget** | Latest + 24h change | Faster TTL via paid plan |

**Orbit Insight** text on the detail screen is **not** provided by FX rate APIs — that needs news/LLM/content, or static/editorial copy.

---

## 15. Summary

You can add currency rates by:

1. **Calling a free API** (Frankfurter, ECB, freemium tiers)  
2. **Calling a paid FX API** (ExchangeRate-API Pro, Fixer, OXR, XE, OANDA, …)  
3. **Proxying through your backend** (best for keys + cache)  
4. **Self-hosting** open rate software  
5. **Combining** latest from one vendor + history from another  
6. **Caching locally** so free tiers and widgets stay viable  

For this converter, the practical path is:

**Frankfurter now → ExchangeRate-API (or Fixer) when you need fresher “live” rates → backend cache before scale.**

---

*Last updated: July 2026. Pricing and free-tier limits change — always verify on the provider’s website before shipping.*
