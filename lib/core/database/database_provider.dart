// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'database_connection.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  final database = AppDatabase(openDeviceDatabase());
  ref.onDispose(database.close);
  return database;
});
