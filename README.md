# Countdown

Countdown is an offline subscription tracker.

## Dependencies

- Flutter 3.47.7 stable (Dart 3.13)
- JDK 17 and the Android SDK, for Android builds
- Xcode with iOS 15 or later, for iOS builds

Packages are listed in `pubspec.yaml`. The UI uses the official `material_ui` package.

## Build

```
flutter pub get
dart run build_runner build
flutter gen-l10n
flutter run
```

Release builds:

```
flutter build apk
flutter build ios
```

Checks:

```
flutter analyze
flutter test
```

Generated files (`*.g.dart`, `lib/l10n/generated/`) are not committed. Run `build_runner` and `gen-l10n` after a fresh clone.

## Database

The database is a Drift database defined in `lib/core/database/app_database.dart`. The current schema version is 1. Schema snapshots are stored in `drift_schemas/`.

To change the schema:

1. Edit the table classes and raise `schemaVersion`.
2. Run `dart run drift_dev schema dump lib/core/database/app_database.dart drift_schemas/`.
3. Run `dart run drift_dev schema steps drift_schemas lib/core/database/schema_versions.dart`.
4. Add `onUpgrade: stepByStep(...)` to `migration` in `AppDatabase`.

## Notifications

Reminders are scheduled locally for 09:00 on the day that is the configured number of days before a charge. The global value is set in Settings and can be overridden per subscription. At most 60 reminders are scheduled at a time, the earliest first. The schedule is rebuilt whenever the app starts or the data changes.

## Statistics

- Spending by category is the monthly equivalent cost. Weekly, yearly and custom periods are converted to a month.
- Spending by month is the sum of charges due in the current month (from today) and the next five months.
- Each currency is shown separately. There is no conversion.

## Data formats

Export and import formats are described in [docs/data-formats.md](docs/data-formats.md).

## Home screen widget

The widget shows the nearest upcoming charge.

- Android: `CountdownWidgetProvider` in `android/app/src/main/kotlin`.
- iOS: the `CountdownWidget` target in `ios/`. The app and the widget share the App Group `group.dev.anmitali.countdown`.

The identifier `dev.anmitali.countdown` is used in the Android `applicationId`, the iOS bundle identifiers and the App Group. When the identifier is changed, update `android/app/build.gradle.kts`, `ios/Runner.xcodeproj`, both `.entitlements` files and `widgetAppGroupId` in `lib/core/platform/home_widget_bridge.dart`.

## Material 3 Expressive

The app uses the components in `material_ui`. At version 1.6.0 the package supports Expressive only for `IconButton`, through `StyleVariant.material3Expressive`. Other Expressive components are not available in the package and are not used.

## Acknowledgments

Countdown is built with Flutter, Riverpod, Drift, go_router, flutter_local_notifications, home_widget, dynamic_color, file_picker, csv, intl and timezone. Thanks to their authors and maintainers.

## Links

- [Contributing](CONTRIBUTING.md)
- [Data formats](docs/data-formats.md)

## License

GPL-3.0-or-later. See [LICENSE](LICENSE).
