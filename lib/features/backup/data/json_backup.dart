// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:convert';

import '../domain/backup_data.dart';
import 'backup_fields.dart';

String encodeJsonBackup(BackupData data) {
  final map = {
    'version': backupVersion,
    'reminderDays': data.reminderDays,
    'subscriptions': [
      for (final subscription in data.subscriptions)
        {
          'name': subscription.name,
          'cost': subscription.cost,
          'currency': subscription.currency,
          'periodUnit': subscription.period.unit.name,
          'periodCount': subscription.period.count,
          'nextChargeDate': formatBackupDate(subscription.nextChargeDate),
          'category': subscription.category.name,
          'note': subscription.note,
          'serviceUrl': subscription.serviceUrl,
          'color': subscription.color,
          'reminderDays': subscription.reminderDays,
        },
    ],
  };
  return const JsonEncoder.withIndent('  ').convert(map);
}

BackupData decodeJsonBackup(String text) {
  final root = jsonDecode(text);
  if (root is! Map<String, dynamic> || root['version'] != backupVersion) {
    throw const FormatException('Unsupported backup file');
  }
  final reminderDays = root['reminderDays'];
  final items = root['subscriptions'];
  if (items is! List ||
      (reminderDays != null && (reminderDays is! int || reminderDays < 0))) {
    throw const FormatException('Invalid backup file');
  }
  return BackupData(
    subscriptions: [
      for (final item in items)
        if (item is Map<String, dynamic>)
          subscriptionFromFields(
            name: _text(item['name']),
            cost: _text(item['cost']),
            currency: _text(item['currency']),
            periodUnit: _text(item['periodUnit']),
            periodCount: _text(item['periodCount']),
            nextChargeDate: _text(item['nextChargeDate']),
            category: _text(item['category']),
            note: _text(item['note']),
            serviceUrl: _text(item['serviceUrl']),
            color: _text(item['color']),
            reminderDays: _text(item['reminderDays']),
          )
        else
          throw const FormatException('Invalid subscription entry'),
    ],
    reminderDays: reminderDays as int?,
  );
}

String _text(Object? value) => value == null ? '' : value.toString();
