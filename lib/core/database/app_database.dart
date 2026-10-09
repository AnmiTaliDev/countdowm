// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:drift/drift.dart';

import '../../features/settings/data/app_settings_table.dart';
import '../../features/subscriptions/data/subscriptions_table.dart';
import '../../features/subscriptions/domain/billing_period.dart';
import '../../features/subscriptions/domain/subscription_category.dart';

part 'app_database.g.dart';

const int defaultReminderDays = 3;
const int settingsRowId = 1;

@DriftDatabase(tables: [Subscriptions, AppSettings])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.connection);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (migrator) async {
        await migrator.createAll();
        await into(appSettings).insert(
          AppSettingsCompanion.insert(
            id: const Value(settingsRowId),
            reminderDays: defaultReminderDays,
          ),
        );
      },
    );
  }
}
