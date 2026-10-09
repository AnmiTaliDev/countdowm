// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/features/subscriptions/domain/billing_period.dart';
import 'package:countdown/features/subscriptions/domain/charge_schedule.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/sample_subscriptions.dart';

void main() {
  final now = DateTime(2026, 10, 9, 15, 30);

  test('future date is returned unchanged', () {
    final subscription = sampleSubscription(
      nextChargeDate: DateTime(2026, 10, 20),
    );
    expect(nextCharge(subscription, now), DateTime(2026, 10, 20));
  });

  test('past date rolls forward by whole periods', () {
    final subscription = sampleSubscription(
      nextChargeDate: DateTime(2026, 6, 15),
    );
    expect(nextCharge(subscription, now), DateTime(2026, 10, 15));
  });

  test('charge today is kept', () {
    final subscription = sampleSubscription(
      nextChargeDate: DateTime(2026, 10, 9),
    );
    expect(nextCharge(subscription, now), DateTime(2026, 10, 9));
  });

  test('chargesBetween lists every occurrence in range', () {
    final subscription = sampleSubscription(
      period: const BillingPeriod(PeriodUnit.week, 1),
      nextChargeDate: DateTime(2026, 9, 1),
    );
    final dates = chargesBetween(
      subscription,
      DateTime(2026, 10, 1),
      DateTime(2026, 10, 31),
    );
    expect(dates, [
      DateTime(2026, 10, 6),
      DateTime(2026, 10, 13),
      DateTime(2026, 10, 20),
      DateTime(2026, 10, 27),
    ]);
  });

  test('countdown reports days and hours', () {
    final countdown = countdownTo(DateTime(2026, 10, 12), now);
    expect(countdown.isToday, isFalse);
    expect(countdown.days, 2);
    expect(countdown.hours, 8);
  });

  test('countdown reports today', () {
    expect(countdownTo(DateTime(2026, 10, 9), now).isToday, isTrue);
  });

  test('seven day window is inclusive of the seventh day', () {
    final inside = sampleSubscription(nextChargeDate: DateTime(2026, 10, 16));
    final outside = sampleSubscription(nextChargeDate: DateTime(2026, 10, 17));
    expect(chargesWithinDays(inside, now, 7), isTrue);
    expect(chargesWithinDays(outside, now, 7), isFalse);
  });
}
