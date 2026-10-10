// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../platform/platform_support.dart';

QueryExecutor openDeviceDatabase() {
  return driftDatabase(
    name: 'countdown',
    native: usesAppSupportDirectory
        ? DriftNativeOptions(databaseDirectory: getApplicationSupportDirectory)
        : null,
  );
}
