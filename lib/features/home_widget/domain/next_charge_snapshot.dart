// SPDX-License-Identifier: GPL-3.0-or-later

import '../../subscriptions/domain/charge_schedule.dart';
import '../../subscriptions/domain/subscription.dart';

class NextChargeSnapshot {
  const NextChargeSnapshot({required this.subscription, required this.date});

  final Subscription subscription;
  final DateTime date;
}

NextChargeSnapshot? nearestCharge(
  List<Subscription> subscriptions,
  DateTime now,
) {
  NextChargeSnapshot? nearest;
  for (final subscription in subscriptions) {
    final date = nextCharge(subscription, now);
    if (nearest == null || date.isBefore(nearest.date)) {
      nearest = NextChargeSnapshot(subscription: subscription, date: date);
    }
  }
  return nearest;
}
