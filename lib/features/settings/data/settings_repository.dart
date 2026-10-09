// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';

class SettingsRepository {
  SettingsRepository(this._database);

  final AppDatabase _database;

  Stream<int> watchReminderDays() {
    final query = _database.select(_database.appSettings)
      ..where((table) => table.id.equals(settingsRowId));
    return query.watchSingle().map((row) => row.reminderDays);
  }

  Future<int> reminderDays() async {
    final query = _database.select(_database.appSettings)
      ..where((table) => table.id.equals(settingsRowId));
    final row = await query.getSingle();
    return row.reminderDays;
  }

  Future<void> setReminderDays(int days) async {
    await (_database.update(_database.appSettings)
          ..where((table) => table.id.equals(settingsRowId)))
        .write(AppSettingsCompanion(reminderDays: Value(days)));
  }
}
