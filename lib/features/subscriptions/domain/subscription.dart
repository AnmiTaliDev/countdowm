// SPDX-License-Identifier: GPL-3.0-or-later

import 'billing_period.dart';
import 'subscription_category.dart';

class Subscription {
  const Subscription({
    this.id,
    required this.name,
    required this.cost,
    required this.currency,
    required this.period,
    required this.nextChargeDate,
    required this.category,
    required this.note,
    required this.serviceUrl,
    required this.color,
    required this.reminderDays,
  });

  final int? id;
  final String name;
  final double cost;
  final String currency;
  final BillingPeriod period;
  final DateTime nextChargeDate;
  final SubscriptionCategory category;
  final String note;
  final String serviceUrl;
  final int color;
  final int? reminderDays;
}
