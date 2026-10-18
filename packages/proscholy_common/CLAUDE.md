# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`proscholy_common` is a Flutter package (with a small native plugin in `android/` and `ios/`) that holds nearly all
code of three songbook apps. Each app is a thin repo with its own `main.dart`, Firebase/Sentry setup, fonts and offline
data, living next to this repo:

| Target | App repo | Website |
| --- | --- | --- |
| `ZPS` | `../proscholy-flutter` | zpevnik.proscholy.cz |
| `EZ` | `../evangelicky-zpevnik-phone` | evangelickyzpevnik.cz |
| `EK` | `../evangelicky-kancional-phone` | evangelickykancional.cz |

The target is a compile-time define, `--dart-define=ZPEVNIK_TARGET=<ZPS|EZ|EK>`, read as `isZPS`/`isEZ`/`isEK` in
`lib/constants.dart`. It changes JSON parsing (EZ/EK take song number and name from songbook 58/63), API headers
(`Filter-Content`), links and UI. Every change must keep all three targets working.

Apps depend on this repo via git, and locally via a gitignored `pubspec_overrides.yaml` pointing to
`../proscholy-common`, so app builds use whatever branch is checked out here.

The UI is Czech only; strings are written inline, there is no localization.

## Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed, json_serializable, riverpod, objectbox
flutter analyze
# page width 120, trailing commas preserved, never format generated files
dart format $(git ls-files 'lib/*.dart' 'test/*.dart' | grep -v -e '/generated/' -e '\.g\.dart$' -e '\.freezed\.dart$')

./init_test.sh                                             # once per objectbox version: installs native objectbox library
flutter test --dart-define=ZPEVNIK_TARGET=ZPS
flutter test test/setup_test.dart --plain-name 'objectbox store' --dart-define=ZPEVNIK_TARGET=ZPS

# benchmarks with assets/data.json of the app next to this repo, results are saved to build/benchmarks
flutter test benchmark --dart-define=ZPEVNIK_TARGET=ZPS
# requests to API run only on demand, as they load the server
flutter test benchmark/api_benchmark_test.dart --dart-define=ZPEVNIK_TARGET=ZPS --dart-define=LIVE_API=true
```

Run an app from its repo, e.g. `cd ../proscholy-flutter && flutter run --dart-define=ZPEVNIK_TARGET=ZPS`.

Tests get an in-memory ObjectBox store and an FTS database from `test/utils.dart`. The FTS database uses system SQLite,
because the SQLite bundled with package `sqlite3` lacks FTS4. Mocks use mocktail, not mockito.

CI (`.github/workflows/test.yml`) checks formatting, runs the analyzer (any issue fails) and runs tests for
every target. Format only handwritten files, generated ones are excluded.

## Architecture

- **Dependencies are injected by the app.** `appDependenciesProvider` (`lib/providers/app_dependencies.dart`) throws
  until the app overrides it in `ProviderScope` with `AppDependencies`: `SharedPreferences`, ObjectBox `Store`,
  sqflite `Database` used for full-text search, and `PackageInfo`. Tests override it the same way.
- **Models** (`lib/models`) are freezed classes that are at the same time ObjectBox entities (`@Entity(realClass: ...)`)
  and are parsed from API JSON. Relations use `ToOne`/`ToMany`; equality is by `id`.
- **State** is Riverpod 3 with code generation (`@riverpod`) in `lib/providers`. Providers read the store through
  helpers in `lib/providers/utils.dart`.
- **Data flow** (`lib/providers/update.dart`):
  - On first start of a new app version, `loadInitial` imports the app's `assets/data.json` snapshot (ZPS creates it
    with `init_data.py`) into ObjectBox and rebuilds the FTS index.
  - Afterwards `updateProvider` asks the GraphQL API (`lib/utils/client.dart`) at most once an hour for changes since
    `last_update`. When a new `data.json` is generated, bump `_initialLastUpdate` for that target.
- **Search** (`lib/providers/search.dart`) combines a FTS4 table `song_lyrics_search` ranked by bm25
  (`lib/custom/sqlite-bm25`) with matching by song id (ZPS only) and songbook number.
- **Routing** is Navigator 1 with `AppRouter.generateRoute` (`lib/routing/router.dart`). Internal routes are English.
  The Czech paths (`/hledani`, `/zpevniky`, `/pisen/<id>`, `/zpevnik/<id>`) are deep links from the websites.
- **Native features** are reached through method channels in `lib/utils/services`. The matching Kotlin/Swift code is in
  `android/src` and `ios/proscholy_common/Sources/proscholy_common` (a Swift package, which the podspec also uses):
  - presentation on an external display runs a second Flutter engine, which starts at the app's `mainPresentation`
    entry point;
  - shared `.proscholy` playlist files;
  - iOS Spotlight indexing.
- **Bible passages** for playlists come from api.getbible.net (`lib/utils/bible_api_client.dart`).

## Rules that are easy to break

- **Generated code is committed** because apps consume this package from git without running build_runner. Outputs go
  to `generated/` folders (see `build.yaml`). Never edit them by hand. Commit regenerated output in the same commit as
  the change that caused it, so every commit works for the apps. The exception is churn from a generator upgrade
  that rewrites unrelated files: commit that on its own.
- **`lib/models/generated/objectbox-model.json` holds entity and property UIDs.** Renaming an entity or property
  without keeping its UID drops that data on update. That includes user data: playlists, user texts, song settings.
  Rename with `@Entity(uid: ...)` / `@Property(uid: ...)` and check the diff of `objectbox-model.json`. Once it has
  the new names, the annotations can be removed again.
  `test/models/store_upgrade_test.dart` opens a store saved by the app before the renames and checks that user data
  are kept.
- **Fonts** in `assets/fonts` must also be declared in each app's `pubspec.yaml`, otherwise they are not bundled.
- **`riverpod_annotation` is pinned** to the version that `riverpod_generator` depends on. Apps resolve riverpod
  without the generator, and a newer riverpod doesn't compile the committed generated code, so upgrade them together.

## Style

- Match the surrounding code: `package:proscholy_common/...` imports, short lowercase comments only where the code is
  not obvious, blank lines between logical steps.
- Commit messages are short, lowercase and imperative (`fix ...`, `refactor ...`, `add ...`).
