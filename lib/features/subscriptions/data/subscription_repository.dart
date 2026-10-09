// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/billing_period.dart';
import '../domain/subscription.dart';

class SubscriptionRepository {
  SubscriptionRepository(this._database);

  final AppDatabase _database;

  Stream<List<Subscription>> watchAll() {
    return _database
        .select(_database.subscriptions)
        .watch()
        .map((rows) => rows.map(_fromRow).toList());
  }

  Future<Subscription?> findById(int id) async {
    final query = _database.select(_database.subscriptions)
      ..where((table) => table.id.equals(id));
    final row = await query.getSingleOrNull();
    return row == null ? null : _fromRow(row);
  }

  Future<void> save(Subscription subscription) async {
    final id = subscription.id;
    if (id == null) {
      await _database
          .into(_database.subscriptions)
          .insert(_toCompanion(subscription));
    } else {
      await (_database.update(_database.subscriptions)
            ..where((table) => table.id.equals(id)))
          .write(_toCompanion(subscription));
    }
  }

  Future<void> delete(int id) async {
    await (_database.delete(
      _database.subscriptions,
    )..where((table) => table.id.equals(id))).go();
  }

  Future<void> replaceAll(List<Subscription> subscriptions) {
    return _database.transaction(() async {
      await _database.delete(_database.subscriptions).go();
      await _database.batch((batch) {
        batch.insertAll(
          _database.subscriptions,
          subscriptions.map(_toCompanion).toList(),
        );
      });
    });
  }

  Subscription _fromRow(SubscriptionRow row) {
    return Subscription(
      id: row.id,
      name: row.name,
      cost: row.cost,
      currency: row.currency,
      period: BillingPeriod(row.periodUnit, row.periodCount),
      nextChargeDate: row.nextChargeDate,
      category: row.category,
      note: row.note,
      serviceUrl: row.serviceUrl,
      color: row.color,
      reminderDays: row.reminderDays,
    );
  }

  SubscriptionsCompanion _toCompanion(Subscription subscription) {
    return SubscriptionsCompanion(
      name: Value(subscription.name),
      cost: Value(subscription.cost),
      currency: Value(subscription.currency),
      periodUnit: Value(subscription.period.unit),
      periodCount: Value(subscription.period.count),
      nextChargeDate: Value(subscription.nextChargeDate),
      category: Value(subscription.category),
      note: Value(subscription.note),
      serviceUrl: Value(subscription.serviceUrl),
      color: Value(subscription.color),
      reminderDays: Value(subscription.reminderDays),
    );
  }
}
