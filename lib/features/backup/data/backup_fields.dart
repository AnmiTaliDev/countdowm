// SPDX-License-Identifier: GPL-3.0-or-later

import '../../subscriptions/domain/billing_period.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/domain/subscription_category.dart';

const int backupVersion = 1;

String formatBackupDate(DateTime date) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  return '${date.year.toString().padLeft(4, '0')}-$month-$day';
}

DateTime parseBackupDate(String value) {
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(value);
  if (match == null) {
    throw FormatException('Invalid date: $value');
  }
  final year = int.parse(match.group(1)!);
  final month = int.parse(match.group(2)!);
  final day = int.parse(match.group(3)!);
  final date = DateTime(year, month, day);
  if (date.month != month || date.day != day) {
    throw FormatException('Invalid date: $value');
  }
  return date;
}

Subscription subscriptionFromFields({
  required String name,
  required String cost,
  required String currency,
  required String periodUnit,
  required String periodCount,
  required String nextChargeDate,
  required String category,
  required String note,
  required String serviceUrl,
  required String color,
  required String reminderDays,
}) {
  final parsedCost = double.tryParse(cost);
  final parsedCount = int.tryParse(periodCount);
  final parsedColor = int.tryParse(color);
  final parsedReminder = reminderDays.isEmpty
      ? null
      : int.tryParse(reminderDays);
  final parsedUnit = PeriodUnit.values.asNameMap()[periodUnit];
  final parsedCategory = SubscriptionCategory.values.asNameMap()[category];
  if (name.isEmpty ||
      parsedCost == null ||
      parsedCost <= 0 ||
      currency.length != 3 ||
      parsedUnit == null ||
      parsedCategory == null ||
      parsedCount == null ||
      parsedCount < 1 ||
      parsedColor == null ||
      (reminderDays.isNotEmpty &&
          (parsedReminder == null || parsedReminder < 0))) {
    throw FormatException('Invalid subscription: $name');
  }
  return Subscription(
    name: name,
    cost: parsedCost,
    currency: currency.toUpperCase(),
    period: BillingPeriod(parsedUnit, parsedCount),
    nextChargeDate: parseBackupDate(nextChargeDate),
    category: parsedCategory,
    note: note,
    serviceUrl: serviceUrl,
    color: parsedColor,
    reminderDays: parsedReminder,
  );
}
