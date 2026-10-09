// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/core/database/app_database.dart';
import 'package:countdown/features/settings/data/settings_repository.dart';
import 'package:countdown/features/subscriptions/data/subscription_repository.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/sample_subscriptions.dart';

void main() {
  late AppDatabase database;
  late SubscriptionRepository repository;
  late SettingsRepository settings;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = SubscriptionRepository(database);
    settings = SettingsRepository(database);
  });

  tearDown(() => database.close());

  test('insert, update and delete', () async {
    await repository.save(
      sampleSubscription(name: 'One', nextChargeDate: DateTime(2026, 11, 1)),
    );
    var all = await repository.watchAll().first;
    expect(all.single.name, 'One');
    expect(all.single.id, isNotNull);

    await repository.save(
      sampleSubscription(
        id: all.single.id,
        name: 'Renamed',
        nextChargeDate: DateTime(2026, 11, 2),
      ),
    );
    all = await repository.watchAll().first;
    expect(all.single.name, 'Renamed');
    expect(all.single.nextChargeDate, DateTime(2026, 11, 2));

    await repository.delete(all.single.id!);
    expect(await repository.watchAll().first, isEmpty);
  });

  test('findById returns null for a missing row', () async {
    expect(await repository.findById(42), isNull);
  });

  test('replaceAll swaps the whole table', () async {
    await repository.save(
      sampleSubscription(name: 'Old', nextChargeDate: DateTime(2026, 11, 1)),
    );
    await repository.replaceAll([
      sampleSubscription(name: 'New 1', nextChargeDate: DateTime(2026, 11, 1)),
      sampleSubscription(name: 'New 2', nextChargeDate: DateTime(2026, 11, 2)),
    ]);
    final names = (await repository.watchAll().first)
        .map((item) => item.name)
        .toSet();
    expect(names, {'New 1', 'New 2'});
  });

  test('settings start with the default reminder and can be changed', () async {
    expect(await settings.reminderDays(), defaultReminderDays);
    await settings.setReminderDays(10);
    expect(await settings.watchReminderDays().first, 10);
  });
}
