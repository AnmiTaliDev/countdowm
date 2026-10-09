// SPDX-License-Identifier: GPL-3.0-or-later

import '../../subscriptions/domain/charge_schedule.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/domain/subscription_category.dart';

const int statisticsMonths = 6;

class MonthTotal {
  const MonthTotal({required this.month, required this.total});

  final DateTime month;
  final double total;
}

class CurrencyStatistics {
  const CurrencyStatistics({
    required this.currency,
    required this.byCategory,
    required this.byMonth,
  });

  final String currency;
  final Map<SubscriptionCategory, double> byCategory;
  final List<MonthTotal> byMonth;
}

List<CurrencyStatistics> computeStatistics(
  List<Subscription> subscriptions,
  DateTime now,
) {
  final currencies = <String>{
    for (final subscription in subscriptions) subscription.currency,
  }.toList()..sort();
  return [
    for (final currency in currencies)
      _forCurrency(
        currency,
        subscriptions.where((item) => item.currency == currency).toList(),
        now,
      ),
  ];
}

CurrencyStatistics _forCurrency(
  String currency,
  List<Subscription> subscriptions,
  DateTime now,
) {
  final byCategory = <SubscriptionCategory, double>{};
  for (final subscription in subscriptions) {
    final monthly = subscription.cost * subscription.period.monthlyFactor;
    byCategory[subscription.category] =
        (byCategory[subscription.category] ?? 0) + monthly;
  }

  final byMonth = <MonthTotal>[];
  for (var offset = 0; offset < statisticsMonths; offset++) {
    final month = DateTime(now.year, now.month + offset);
    final first = offset == 0 ? dateOnly(now) : month;
    final last = DateTime(month.year, month.month + 1, 0);
    var total = 0.0;
    for (final subscription in subscriptions) {
      total +=
          subscription.cost * chargesBetween(subscription, first, last).length;
    }
    byMonth.add(MonthTotal(month: month, total: total));
  }

  return CurrencyStatistics(
    currency: currency,
    byCategory: byCategory,
    byMonth: byMonth,
  );
}
