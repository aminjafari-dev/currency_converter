# Home Widget Feature

## Description

The **home_widget** feature prepares a domain-ready snapshot for a future Android/iOS home-screen widget matching Stitch `04_home_widget`. v1 registers the `home_widget` package dependency and implements entities + a use case + a **stub** repository. Native Glance / WidgetKit UI is intentionally deferred.

## Architecture

- `home_widget_di.dart`
- **Domain**
  - `entities/widget_snapshot.dart` — base, rates with % change, updatedAt
  - `repositories/home_widget_repository.dart`
  - `usecases/build_home_widget_snapshot.dart` — composes data from rates domain
- **Data**
  - `repositories/home_widget_repository_stub.dart` — no-op / log only

## Use Cases

1. **Use Case:** `BuildHomeWidgetSnapshot`  
   **Description:** Builds a widget payload from selected currencies + latest rates and pushes it to `HomeWidgetRepository`.  
   **Data Flow:** Caller -> BuildHomeWidgetSnapshot -> rates use cases -> HomeWidgetRepositoryStub

## Data Flow

1. Call `BuildHomeWidgetSnapshot(NoParams())`
2. Resolve base + up to 3 quote currencies from selection
3. Attach latest rates and timestamp
4. Stub repository acknowledges without native I/O

## Next step (deferred)

- Add Android App Widget / Glance layout and iOS WidgetKit extension
- Replace stub with `HomeWidget.saveWidgetData` / `HomeWidget.updateWidget`
- Schedule background refresh (WorkManager / BGTask) respecting OS limits

## Key Components

- Domain-ready Clean Architecture
- Stub repository pattern for swappable native bridge
- Depends on rates domain only
