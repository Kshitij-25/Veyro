# Fitness Trakcer

Offline-first fitness tracker for iOS, Android and (secondarily) web, built with
Flutter using feature-first clean architecture. All data lives on the device
(Drift/SQLite); there are no accounts.

> The package is named `fitness_trakcer` (as created). Rename it with
> `dart pub global run rename` or by hand if you want to fix the spelling.

## Features

| Feature | What it does |
| --- | --- |
| `profile` | Onboarding, profile, metric/imperial unit preference |
| `workout` | Active workout logging (exercises, sets, reps, weight, duration, distance), exercise library (built-in, custom, ~900 downloadable from wger), history, personal records, rest timer |
| `routines` | Reusable routines, weekly schedule, start a workout from a routine |
| `activity` | Daily steps / distance / active calories from HealthKit / Health Connect, manual entry fallback |
| `body_metrics` | Weight and body measurements, trend, BMI |
| `goals` | Daily/weekly/target goals, progress, streaks, achievements |
| `reminders` | Repeating local notifications (workout, water, weigh-in, ...) |
| `gps_tracking` | Record runs/walks/rides: distance, pace, elevation, route, calories |
| `dashboard` | "Today" summary across all features |

## Architecture

```
lib/
  main.dart                 entry point
  app/                      root widget (providers, theme, router)
  core/                     shared, feature-agnostic code
    bootstrap/              start-up work
    database/               Drift database + tables
    di/                     get_it + injectable setup and platform modules
    error/                  Failure types
    extensions/ units/ utils/
    layout/                 window size classes, adaptive scaffold, two-pane, ...
    router/                 go_router config, adaptive app shell
    theme/ usecase/ widgets/
  features/<feature>/
    domain/                 entities, repository interfaces, use cases (pure Dart)
    data/                   data sources, mappers, repository implementations
    presentation/           cubits, pages, widgets
```

- **Dependency rule:** `presentation -> domain <- data`. The domain layer has no
  Flutter or plugin imports. Platform plugins (health, geolocator,
  notifications) sit behind domain/data interfaces and have web/desktop
  fallbacks.
- **Results, not exceptions:** one-shot repository and use case calls return
  `Result<T>` (`Success` / `Fail` with a `Failure`). Reactive reads are
  `Stream`s; errors surface through the stream.
- **State management:** Cubit. `ProfileCubit`, `ActiveWorkoutCubit`,
  `RestTimerCubit`, `TrackingCubit` and `DashboardCubit` are app-scoped; every
  other cubit is created per route.
- **Storage:** everything is stored in metric units. `UnitSystem` /
  `UnitConverter` / `UnitFormatter` convert for display and input.

### Naming conventions

- Files: `snake_case`, suffixed by role - `*_repository.dart`,
  `*_repository_impl.dart`, `*_local_data_source.dart`, `*_mapper.dart`,
  `*_cubit.dart` (state in `*_state.dart` or the same file), `*_page.dart`.
- Use cases are verbs (`LogWater`, `FinishWorkout`), take one params object
  and expose `call`.
- Drift tables are plural (`Workouts`) with row classes named `*Row`; domain
  entities have the plain name (`Workout`).

## Adaptive / responsive

- `WindowSizeClass` (compact < 600, medium < 840, expanded) drives layout.
- `AdaptiveScaffold` switches between a bottom `NavigationBar` (phones), a
  `NavigationRail` (small tablets) and an extended rail (large tablets, web).
- `ContentConstraint` caps content width; `ResponsiveBuilder` and
  `AdaptiveTwoPane` help build list/detail layouts.
- Adaptive widgets are used where Flutter offers them (`showAdaptiveDialog`,
  `AlertDialog.adaptive`, `Switch.adaptive`, `CircularProgressIndicator.adaptive`).

## Replacing the placeholder UI

Pages under `features/*/presentation/pages` are intentionally bare: each one
only reads its cubit state and calls cubit methods. Replace the widget tree
freely - cubits, states and routes stay as they are. Routes live in
`core/router/app_router.dart` / `app_routes.dart`.

## Setup

```bash
flutter pub get
dart run build_runner build   # freezed, drift, injectable
flutter run
```

Re-run `build_runner` after changing a Drift table, a `@freezed` class or an
`@injectable` annotation (`dart run build_runner watch` while developing).

### Data sources

| Data | Source | Notes |
| --- | --- | --- |
| Extra exercises | [wger](https://wger.de) API, fetched and cached in the DB | CC-BY-SA 4.0, credited in-app. Refreshed in the background when older than 30 days, or with the download button in the exercise library. Names that already exist are skipped. |

### Platform notes

- **iOS HealthKit:** the capability is enabled (`ios/Runner/Runner.entitlements`,
  wired into the Xcode project). Running on a device needs a development team
  with the HealthKit capability in your Apple Developer account. Usage
  descriptions, background location and notification setup are in `Info.plist`
  / `AppDelegate.swift`.
- **Android:** `minSdk` is 26 (Health Connect). The user needs the Health
  Connect app on Android 13 and below. Permissions, receivers and desugaring
  are configured.
- **Web:** `web/sqlite3.wasm` and `web/drift_worker.js` (drift 2.35.1 release
  assets) are checked in. If you upgrade `drift`, download the matching files
  from <https://github.com/simolus3/drift/releases>. Health data and local
  notifications are unavailable on web - the app falls back to manual activity
  entry and stored-but-silent reminders.
- Reminders use inexact alarms (no exact-alarm permission), so they may fire a
  few minutes late on Android.

### Removed: nutrition

Food diary, water log, food library, barcode scanning and photo suggestions
were removed on purpose while the feature is re-planned (goals for calorie and
water intake and the "Drink water" / "Log a meal" reminders went with it).
Database schema v3 drops the old tables on upgrade.
