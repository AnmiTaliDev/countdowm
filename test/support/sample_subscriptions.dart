// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/features/subscriptions/domain/billing_period.dart';
import 'package:countdown/features/subscriptions/domain/subscription.dart';
import 'package:countdown/features/subscriptions/domain/subscription_category.dart';

Subscription sampleSubscription({
  int? id,
  String name = 'Service',
  double cost = 10,
  String currency = 'USD',
  BillingPeriod period = const BillingPeriod(PeriodUnit.month, 1),
  required DateTime nextChargeDate,
  SubscriptionCategory category = SubscriptionCategory.other,
  int? reminderDays,
}) {
  return Subscription(
    id: id,
    name: name,
    cost: cost,
    currency: currency,
    period: period,
    nextChargeDate: nextChargeDate,
    category: category,
    note: '',
    serviceUrl: '',
    color: 0xFF6750A4,
    reminderDays: reminderDays,
  );
}
