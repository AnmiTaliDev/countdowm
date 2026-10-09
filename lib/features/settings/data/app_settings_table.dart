// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:drift/drift.dart';

@DataClassName('AppSettingsRow')
class AppSettings extends Table {
  IntColumn get id => integer()();
  IntColumn get reminderDays => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
