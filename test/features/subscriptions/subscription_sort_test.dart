// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/features/subscriptions/domain/subscription_category.dart';
import 'package:countdown/features/subscriptions/domain/subscription_sort.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/sample_subscriptions.dart';

void main() {
  final now = DateTime(2026, 10, 9);
  final a = sampleSubscription(
    name: 'A',
    cost: 5,
    nextChargeDate: DateTime(2026, 10, 20),
    category: SubscriptionCategory.music,
  );
  final b = sampleSubscription(
    name: 'B',
    cost: 20,
    nextChargeDate: DateTime(2026, 10, 12),
    category: SubscriptionCategory.streaming,
  );
  final c = sampleSubscription(
    name: 'C',
    cost: 8,
    currency: 'EUR',
    nextChargeDate: DateTime(2026, 10, 15),
    category: SubscriptionCategory.streaming,
  );

  List<String> names(SortOrder order) {
    return sortSubscriptions(
      [a, b, c],
      order,
      now,
    ).map((item) => item.name).toList();
  }

  test('sorts by nearest date', () {
    expect(names(SortOrder.date), ['B', 'C', 'A']);
  });

  test('sorts by price within each currency', () {
    expect(names(SortOrder.price), ['C', 'B', 'A']);
  });

  test('sorts by category then date', () {
    expect(names(SortOrder.category), ['B', 'C', 'A']);
  });
}
