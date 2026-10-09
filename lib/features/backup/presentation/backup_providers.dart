// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/platform/file_storage.dart';
import '../../settings/presentation/settings_providers.dart';
import '../../subscriptions/presentation/subscription_providers.dart';
import '../data/backup_service.dart';

final fileStorageProvider = Provider<FileStorage>((ref) => FileStorage());

final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(
    ref.watch(subscriptionRepositoryProvider),
    ref.watch(settingsRepositoryProvider),
    ref.watch(fileStorageProvider),
  );
});
