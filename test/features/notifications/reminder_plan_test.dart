// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/features/notifications/domain/reminder_plan.dart';
import 'package:countdown/features/subscriptions/domain/billing_period.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/sample_subscriptions.dart';

void main() {
  final now = DateTime(2026, 10, 9, 12);

  test('uses the global number of days', () {
    final subscription = sampleSubscription(
      nextChargeDate: DateTime(2026, 10, 20),
    );
    final reminders = planReminders([subscription], 3, now);
    expect(reminders.first.fireAt, DateTime(2026, 10, 17, reminderHour));
    expect(reminders.first.daysBefore, 3);
  });

  test('per subscription value overrides the global one', () {
    final subscription = sampleSubscription(
      nextChargeDate: DateTime(2026, 10, 20),
      reminderDays: 1,
    );
    final reminders = planReminders([subscription], 3, now);
    expect(reminders.first.fireAt, DateTime(2026, 10, 19, reminderHour));
    expect(reminders.first.daysBefore, 1);
  });

  test('skips reminders that are already in the past', () {
    final subscription = sampleSubscription(
      nextChargeDate: DateTime(2026, 10, 10),
    );
    final reminders = planReminders([subscription], 3, now);
    expect(reminders.first.fireAt, DateTime(2026, 11, 7, reminderHour));
  });

  test('reminder on the day of the charge', () {
    final subscription = sampleSubscription(
      nextChargeDate: DateTime(2026, 10, 20),
    );
    final reminders = planReminders([subscription], 0, now);
    expect(reminders.first.fireAt, DateTime(2026, 10, 20, reminderHour));
  });

  test(
    'limits the number of scheduled reminders and assigns sequential ids',
    () {
      final subscription = sampleSubscription(
        period: const BillingPeriod(PeriodUnit.day, 1),
        nextChargeDate: DateTime(2026, 10, 10),
      );
      final reminders = planReminders([subscription], 0, now);
      expect(reminders.length, maxScheduledReminders);
      expect(
        reminders.map((item) => item.id),
        List.generate(maxScheduledReminders, (i) => i),
      );
      expect(reminders.first.fireAt.isBefore(reminders.last.fireAt), isTrue);
    },
  );
}
