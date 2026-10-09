// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/features/statistics/domain/statistics.dart';
import 'package:countdown/features/subscriptions/domain/billing_period.dart';
import 'package:countdown/features/subscriptions/domain/subscription_category.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/sample_subscriptions.dart';

void main() {
  final now = DateTime(2026, 10, 9);

  test('totals are computed separately for each currency', () {
    final result = computeStatistics([
      sampleSubscription(
        cost: 10,
        currency: 'USD',
        nextChargeDate: DateTime(2026, 10, 20),
      ),
      sampleSubscription(
        cost: 5,
        currency: 'EUR',
        nextChargeDate: DateTime(2026, 10, 20),
      ),
      sampleSubscription(
        cost: 7,
        currency: 'USD',
        nextChargeDate: DateTime(2026, 10, 25),
      ),
    ], now);
    expect(result.map((item) => item.currency), ['EUR', 'USD']);
    expect(result[1].byMonth.first.total, 17);
    expect(result[0].byMonth.first.total, 5);
  });

  test('category spending uses monthly equivalent cost', () {
    final result = computeStatistics([
      sampleSubscription(
        cost: 120,
        period: const BillingPeriod(PeriodUnit.year, 1),
        nextChargeDate: DateTime(2027, 3, 1),
        category: SubscriptionCategory.software,
      ),
      sampleSubscription(
        cost: 10,
        nextChargeDate: DateTime(2026, 10, 20),
        category: SubscriptionCategory.software,
      ),
    ], now);
    expect(
      result.single.byCategory[SubscriptionCategory.software],
      closeTo(20, 1e-9),
    );
  });

  test('month totals cover six months and count repeated charges', () {
    final result = computeStatistics([
      sampleSubscription(
        cost: 3,
        period: const BillingPeriod(PeriodUnit.week, 1),
        nextChargeDate: DateTime(2026, 10, 12),
      ),
    ], now);
    final months = result.single.byMonth;
    expect(months.length, statisticsMonths);
    expect(months.first.month, DateTime(2026, 10));
    expect(months.first.total, 3 * 3);
    expect(months[1].total, 3 * 5);
  });

  test('charges earlier in the current month are not counted', () {
    final result = computeStatistics([
      sampleSubscription(cost: 10, nextChargeDate: DateTime(2026, 10, 2)),
    ], now);
    expect(result.single.byMonth.first.total, 0);
    expect(result.single.byMonth[1].total, 10);
  });

  test('no subscriptions gives no statistics', () {
    expect(computeStatistics([], now), isEmpty);
  });
}
