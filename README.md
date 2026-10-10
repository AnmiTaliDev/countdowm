# Countdown

Countdown is an offline subscription tracker.

## Dependencies

- Flutter 3.47.7 stable (Dart 3.13)
- JDK 17 and the Android SDK, for Android builds
- Xcode with iOS 15 or later, for iOS builds
- clang, cmake, ninja, pkg-config and the GTK 3 development files, for Linux builds
- `xdg-desktop-portal` with a backend for your desktop, for the file dialogs on Linux

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
flutter build linux
```

Checks:

```
flutter analyze
flutter test
```

Generated files (`*.g.dart`, `lib/l10n/generated/`) are not committed. Run `build_runner` and `gen-l10n` after a fresh clone.

## Localization

User-facing strings are in `lib/l10n/app_en.arb` (template) and `lib/l10n/app_ru.arb`. To add a language, add `app_<code>.arb` with all keys from the template and run `flutter gen-l10n`. The app falls back to English for unsupported device languages.

In plural messages, `=1` is treated as the `one` category by gen-l10n. Languages where `one` also covers other numbers (Russian: 21, 31) need a separate string for the singular case, as done for the billing period labels.

The Android widget strings are in `android/app/src/main/res/values*/strings.xml`. The iOS widget receives its empty-state text from the app. Its gallery name and description are English only.

## Platforms

Android and iOS are the primary targets. Linux is supported with these limits:

- Reminders are not scheduled. `flutter_local_notifications` does not implement scheduled notifications on Linux.
- There is no home screen widget.
- The database is stored in the XDG data directory (`$XDG_DATA_HOME`, usually `~/.local/share`), in a folder named after the application id.

Windows is not supported. The project has no Windows runner. If one is added with `flutter create --platforms=windows .`, the app builds, shows a notice that the platform is not supported, and does nothing else. macOS is not a target and has no runner.

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

## App icon

The icon sources are in `assets/icon/`: `icon.svg` (full icon), `icon_foreground.svg` (adaptive foreground) and `icon_monochrome.svg` (themed icon). The PNG files are rendered from the SVG files at 1024x1024. To regenerate the platform icons after a change:

```
dart run flutter_launcher_icons
```

The configuration is in `flutter_launcher_icons.yaml`. The tool also rewrites two build settings in `ios/Runner.xcodeproj/project.pbxproj`. Revert `ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS` to `YES` in both places.

## Licenses

Countdown is licensed under GPL-3.0-or-later. Third-party components and their licenses are listed in [NOTICE](NOTICE). The application shows the full license texts of all dependencies under Settings, About Countdown, View licenses. The GPL text and the Material Icons font license are registered there from assets (`LICENSE`, `assets/licenses/`).

NOTICE is maintained by hand. Update it when a dependency is added, removed or replaced.

## Material 3 Expressive

The app uses the components in `material_ui`. At version 1.6.0 the package supports Expressive only for `IconButton`, through `StyleVariant.material3Expressive`. Other Expressive components are not available in the package and are not used.

## Acknowledgments

Countdown is built with Flutter, Riverpod, Drift, go_router, flutter_local_notifications, home_widget, dynamic_color, file_picker, csv, intl, timezone and package_info_plus. Thanks to their authors and maintainers.

## Links

- [Contributing](CONTRIBUTING.md)
- [Data formats](docs/data-formats.md)
- [Third-party notices](NOTICE)

## License

GPL-3.0-or-later. See [LICENSE](LICENSE).
