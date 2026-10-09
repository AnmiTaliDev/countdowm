// SPDX-License-Identifier: GPL-3.0-or-later

import 'charge_schedule.dart';
import 'subscription.dart';

enum SortOrder { date, price, category }

List<Subscription> sortSubscriptions(
  List<Subscription> subscriptions,
  SortOrder order,
  DateTime now,
) {
  final sorted = List<Subscription>.of(subscriptions);
  sorted.sort((a, b) {
    final byDate = nextCharge(a, now).compareTo(nextCharge(b, now));
    final primary = switch (order) {
      SortOrder.date => byDate,
      SortOrder.price => _comparePrice(a, b),
      SortOrder.category => a.category.index.compareTo(b.category.index),
    };
    if (primary != 0) {
      return primary;
    }
    if (byDate != 0) {
      return byDate;
    }
    return a.name.toLowerCase().compareTo(b.name.toLowerCase());
  });
  return sorted;
}

int _comparePrice(Subscription a, Subscription b) {
  final byCurrency = a.currency.compareTo(b.currency);
  if (byCurrency != 0) {
    return byCurrency;
  }
  return b.cost.compareTo(a.cost);
}
