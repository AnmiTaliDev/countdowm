// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:csv/csv.dart';

import '../../subscriptions/domain/subscription.dart';
import 'backup_fields.dart';

const List<String> csvColumns = [
  'name',
  'cost',
  'currency',
  'period_unit',
  'period_count',
  'next_charge_date',
  'category',
  'note',
  'service_url',
  'color',
  'reminder_days',
];

String encodeCsvBackup(List<Subscription> subscriptions) {
  final rows = <List<Object?>>[
    csvColumns,
    for (final subscription in subscriptions)
      [
        subscription.name,
        subscription.cost,
        subscription.currency,
        subscription.period.unit.name,
        subscription.period.count,
        formatBackupDate(subscription.nextChargeDate),
        subscription.category.name,
        subscription.note,
        subscription.serviceUrl,
        subscription.color,
        subscription.reminderDays ?? '',
      ],
  ];
  return csv.encode(rows);
}

List<Subscription> decodeCsvBackup(String text) {
  final rows = csv.decode(text);
  if (rows.isEmpty) {
    throw const FormatException('Empty file');
  }
  final header = rows.first.map((cell) => cell.toString().trim()).toList();
  final indexes = <String, int>{};
  for (final column in csvColumns) {
    final index = header.indexOf(column);
    if (index < 0) {
      throw FormatException('Missing column: $column');
    }
    indexes[column] = index;
  }
  return [
    for (final row in rows.skip(1))
      subscriptionFromFields(
        name: _cell(row, indexes['name']!),
        cost: _cell(row, indexes['cost']!),
        currency: _cell(row, indexes['currency']!),
        periodUnit: _cell(row, indexes['period_unit']!),
        periodCount: _cell(row, indexes['period_count']!),
        nextChargeDate: _cell(row, indexes['next_charge_date']!),
        category: _cell(row, indexes['category']!),
        note: _cell(row, indexes['note']!),
        serviceUrl: _cell(row, indexes['service_url']!),
        color: _cell(row, indexes['color']!),
        reminderDays: _cell(row, indexes['reminder_days']!),
      ),
  ];
}

String _cell(List<dynamic> row, int index) {
  return index < row.length ? row[index].toString().trim() : '';
}
