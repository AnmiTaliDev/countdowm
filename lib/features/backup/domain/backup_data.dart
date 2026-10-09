// SPDX-License-Identifier: GPL-3.0-or-later

import '../../subscriptions/domain/subscription.dart';

class BackupData {
  const BackupData({required this.subscriptions, required this.reminderDays});

  final List<Subscription> subscriptions;
  final int? reminderDays;
}
