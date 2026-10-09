// SPDX-License-Identifier: GPL-3.0-or-later

enum PeriodUnit { day, week, month, year }

const double averageDaysPerMonth = 30.4375;

class BillingPeriod {
  const BillingPeriod(this.unit, this.count);

  final PeriodUnit unit;
  final int count;

  DateTime advance(DateTime anchor, int steps) {
    final total = count * steps;
    return switch (unit) {
      PeriodUnit.day => DateTime(anchor.year, anchor.month, anchor.day + total),
      PeriodUnit.week => DateTime(
        anchor.year,
        anchor.month,
        anchor.day + total * 7,
      ),
      PeriodUnit.month => _addMonths(anchor, total),
      PeriodUnit.year => _addMonths(anchor, total * 12),
    };
  }

  double get monthlyFactor {
    return switch (unit) {
      PeriodUnit.day => averageDaysPerMonth / count,
      PeriodUnit.week => averageDaysPerMonth / (7 * count),
      PeriodUnit.month => 1 / count,
      PeriodUnit.year => 1 / (12 * count),
    };
  }

  @override
  bool operator ==(Object other) =>
      other is BillingPeriod && other.unit == unit && other.count == count;

  @override
  int get hashCode => Object.hash(unit, count);
}

DateTime _addMonths(DateTime anchor, int months) {
  final index = anchor.month - 1 + months;
  final year = anchor.year + index ~/ 12;
  final month = index % 12 + 1;
  final lastDay = DateTime(year, month + 1, 0).day;
  final day = anchor.day < lastDay ? anchor.day : lastDay;
  return DateTime(year, month, day);
}
