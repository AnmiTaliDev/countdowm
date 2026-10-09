// SPDX-License-Identifier: GPL-3.0-or-later

import '../../subscriptions/domain/charge_schedule.dart';
import '../../subscriptions/domain/subscription.dart';

const int reminderHour = 9;
const int maxReminderDays = 30;
const int maxScheduledReminders = 60;
const int reminderHorizonDays = 366;

class Reminder {
  const Reminder({
    required this.id,
    required this.fireAt,
    required this.subscription,
    required this.daysBefore,
  });

  final int id;
  final DateTime fireAt;
  final Subscription subscription;
  final int daysBefore;
}

List<Reminder> planReminders(
  List<Subscription> subscriptions,
  int defaultDays,
  DateTime now,
) {
  final start = dateOnly(now);
  final horizon = DateTime(
    start.year,
    start.month,
    start.day + reminderHorizonDays,
  );
  final pending = <({DateTime fireAt, Subscription subscription, int days})>[];
  for (final subscription in subscriptions) {
    final days = subscription.reminderDays ?? defaultDays;
    for (final charge in chargesBetween(subscription, start, horizon)) {
      final fireAt = DateTime(
        charge.year,
        charge.month,
        charge.day - days,
        reminderHour,
      );
      if (fireAt.isAfter(now)) {
        pending.add((fireAt: fireAt, subscription: subscription, days: days));
      }
    }
  }
  pending.sort((a, b) => a.fireAt.compareTo(b.fireAt));
  final limited = pending.take(maxScheduledReminders).toList();
  return [
    for (var index = 0; index < limited.length; index++)
      Reminder(
        id: index,
        fireAt: limited[index].fireAt,
        subscription: limited[index].subscription,
        daysBefore: limited[index].days,
      ),
  ];
}
