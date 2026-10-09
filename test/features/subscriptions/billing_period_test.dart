// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/features/subscriptions/domain/billing_period.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('month advance keeps the anchor day when the month is long enough', () {
    const period = BillingPeriod(PeriodUnit.month, 1);
    final anchor = DateTime(2026, 1, 31);
    expect(period.advance(anchor, 1), DateTime(2026, 2, 28));
    expect(period.advance(anchor, 2), DateTime(2026, 3, 31));
    expect(period.advance(anchor, 3), DateTime(2026, 4, 30));
  });

  test('year advance handles leap day', () {
    const period = BillingPeriod(PeriodUnit.year, 1);
    final anchor = DateTime(2024, 2, 29);
    expect(period.advance(anchor, 1), DateTime(2025, 2, 28));
    expect(period.advance(anchor, 4), DateTime(2028, 2, 29));
  });

  test('week and custom day intervals', () {
    expect(
      const BillingPeriod(PeriodUnit.week, 2).advance(DateTime(2026, 1, 1), 1),
      DateTime(2026, 1, 15),
    );
    expect(
      const BillingPeriod(PeriodUnit.day, 45).advance(DateTime(2026, 1, 1), 1),
      DateTime(2026, 2, 15),
    );
  });

  test('monthly factor normalizes every period to a month', () {
    expect(const BillingPeriod(PeriodUnit.month, 1).monthlyFactor, 1);
    expect(
      const BillingPeriod(PeriodUnit.year, 1).monthlyFactor,
      closeTo(1 / 12, 1e-9),
    );
    expect(
      const BillingPeriod(PeriodUnit.month, 3).monthlyFactor,
      closeTo(1 / 3, 1e-9),
    );
    expect(
      const BillingPeriod(PeriodUnit.week, 1).monthlyFactor,
      closeTo(averageDaysPerMonth / 7, 1e-9),
    );
  });
}
