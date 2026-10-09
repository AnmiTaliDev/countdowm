// SPDX-License-Identifier: GPL-3.0-or-later

import '../../../core/platform/file_storage.dart';
import '../../settings/data/settings_repository.dart';
import '../../subscriptions/data/subscription_repository.dart';
import '../domain/backup_data.dart';
import 'csv_backup.dart';
import 'json_backup.dart';

class BackupService {
  BackupService(this._subscriptions, this._settings, this._files);

  final SubscriptionRepository _subscriptions;
  final SettingsRepository _settings;
  final FileStorage _files;

  Future<bool> exportJson(DateTime now) async {
    final all = await _subscriptions.watchAll().first;
    final content = encodeJsonBackup(
      BackupData(
        subscriptions: all,
        reminderDays: await _settings.reminderDays(),
      ),
    );
    return _files.saveText(
      fileName: 'countdown-${_stamp(now)}.json',
      content: content,
      mimeType: 'application/json',
    );
  }

  Future<bool> exportCsv(DateTime now) async {
    final all = await _subscriptions.watchAll().first;
    return _files.saveText(
      fileName: 'countdown-${_stamp(now)}.csv',
      content: encodeCsvBackup(all),
      mimeType: 'text/csv',
    );
  }

  Future<BackupData?> pickImport() async {
    final file = await _files.pickText(['json', 'csv']);
    if (file == null) {
      return null;
    }
    if (file.name.toLowerCase().endsWith('.csv')) {
      return BackupData(
        subscriptions: decodeCsvBackup(file.content),
        reminderDays: null,
      );
    }
    return decodeJsonBackup(file.content);
  }

  Future<void> applyImport(BackupData data) async {
    await _subscriptions.replaceAll(data.subscriptions);
    final reminderDays = data.reminderDays;
    if (reminderDays != null) {
      await _settings.setReminderDays(reminderDays);
    }
  }

  String _stamp(DateTime now) {
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');
    return '${now.year}$month$day';
  }
}
