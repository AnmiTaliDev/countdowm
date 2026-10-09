// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

QueryExecutor openDeviceDatabase() {
  return driftDatabase(name: 'countdown');
}
