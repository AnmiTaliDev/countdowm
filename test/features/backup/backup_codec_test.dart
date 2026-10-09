// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/features/backup/data/csv_backup.dart';
import 'package:countdown/features/backup/data/json_backup.dart';
import 'package:countdown/features/backup/domain/backup_data.dart';
import 'package:countdown/features/subscriptions/domain/billing_period.dart';
import 'package:countdown/features/subscriptions/domain/subscription.dart';
import 'package:countdown/features/subscriptions/domain/subscription_category.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final original = [
    Subscription(
      name: 'Cloud, "Pro"',
      cost: 9.99,
      currency: 'USD',
      period: const BillingPeriod(PeriodUnit.month, 3),
      nextChargeDate: DateTime(2026, 11, 5),
      category: SubscriptionCategory.cloud,
      note: 'line one\nline two',
      serviceUrl: 'https://example.org',
      color: 0xFF2E7D32,
      reminderDays: 5,
    ),
    Subscription(
      name: 'Music',
      cost: 4,
      currency: 'EUR',
      period: const BillingPeriod(PeriodUnit.year, 1),
      nextChargeDate: DateTime(2027, 1, 1),
      category: SubscriptionCategory.music,
      note: '',
      serviceUrl: '',
      color: 0xFFB3261E,
      reminderDays: null,
    ),
  ];

  void expectSame(List<Subscription> actual) {
    expect(actual.length, original.length);
    for (var i = 0; i < original.length; i++) {
      expect(actual[i].name, original[i].name);
      expect(actual[i].cost, original[i].cost);
      expect(actual[i].currency, original[i].currency);
      expect(actual[i].period, original[i].period);
      expect(actual[i].nextChargeDate, original[i].nextChargeDate);
      expect(actual[i].category, original[i].category);
      expect(actual[i].note, original[i].note);
      expect(actual[i].serviceUrl, original[i].serviceUrl);
      expect(actual[i].color, original[i].color);
      expect(actual[i].reminderDays, original[i].reminderDays);
    }
  }

  test('JSON round trip keeps all fields and the global reminder', () {
    final text = encodeJsonBackup(
      BackupData(subscriptions: original, reminderDays: 7),
    );
    final decoded = decodeJsonBackup(text);
    expect(decoded.reminderDays, 7);
    expectSame(decoded.subscriptions);
  });

  test('CSV round trip keeps all fields', () {
    expectSame(decodeCsvBackup(encodeCsvBackup(original)));
  });

  test('JSON rejects wrong version, bad enum and bad date', () {
    expect(
      () => decodeJsonBackup('{"version":2,"subscriptions":[]}'),
      throwsFormatException,
    );
    expect(() => decodeJsonBackup('not json'), throwsFormatException);
    final text = encodeJsonBackup(
      BackupData(subscriptions: original, reminderDays: null),
    );
    expect(
      () => decodeJsonBackup(text.replaceFirst('"cloud"', '"unknown"')),
      throwsFormatException,
    );
    expect(
      () => decodeJsonBackup(text.replaceFirst('2026-11-05', '2026-13-45')),
      throwsFormatException,
    );
  });

  test('CSV rejects missing columns and invalid values', () {
    expect(() => decodeCsvBackup('name,cost\nA,1'), throwsFormatException);
    expect(() => decodeCsvBackup(''), throwsFormatException);
    final text = encodeCsvBackup(original);
    expect(
      () => decodeCsvBackup(text.replaceFirst('9.99', 'abc')),
      throwsFormatException,
    );
  });
}
