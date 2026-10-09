// SPDX-License-Identifier: GPL-3.0-or-later

import 'subscription.dart';

DateTime dateOnly(DateTime value) {
  return DateTime(value.year, value.month, value.day);
}

DateTime nextCharge(Subscription subscription, DateTime now) {
  final today = dateOnly(now);
  var steps = 0;
  var date = subscription.nextChargeDate;
  while (date.isBefore(today)) {
    steps++;
    date = subscription.period.advance(subscription.nextChargeDate, steps);
  }
  return date;
}

List<DateTime> chargesBetween(
  Subscription subscription,
  DateTime start,
  DateTime end,
) {
  final dates = <DateTime>[];
  var steps = 0;
  var date = subscription.nextChargeDate;
  while (date.isBefore(start)) {
    steps++;
    date = subscription.period.advance(subscription.nextChargeDate, steps);
  }
  while (!date.isAfter(end)) {
    dates.add(date);
    steps++;
    date = subscription.period.advance(subscription.nextChargeDate, steps);
  }
  return dates;
}

class Countdown {
  const Countdown({
    required this.isToday,
    required this.days,
    required this.hours,
  });

  final bool isToday;
  final int days;
  final int hours;
}

Countdown countdownTo(DateTime chargeDate, DateTime now) {
  if (chargeDate == dateOnly(now)) {
    return const Countdown(isToday: true, days: 0, hours: 0);
  }
  final remaining = chargeDate.difference(now);
  return Countdown(
    isToday: false,
    days: remaining.inDays,
    hours: remaining.inHours % 24,
  );
}

bool chargesWithinDays(Subscription subscription, DateTime now, int days) {
  final limit = DateTime(now.year, now.month, now.day + days);
  return !nextCharge(subscription, now).isAfter(limit);
}
