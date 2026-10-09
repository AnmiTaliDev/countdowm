// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/platform/home_widget_bridge.dart';
import '../core/platform/local_notifications.dart';
import '../features/home_widget/data/widget_updater.dart';
import '../features/notifications/data/reminder_scheduler.dart';
import '../features/settings/presentation/settings_providers.dart';
import '../features/subscriptions/presentation/subscription_providers.dart';

final reminderSchedulerProvider = Provider<ReminderScheduler>((ref) {
  return ReminderScheduler(LocalNotifications());
});

final widgetUpdaterProvider = Provider<WidgetUpdater>((ref) {
  return WidgetUpdater(HomeWidgetBridge());
});

final externalSyncProvider = Provider<void>((ref) {
  final subscriptions = ref.watch(subscriptionsProvider).value;
  final reminderDays = ref.watch(reminderDaysProvider).value;
  if (subscriptions == null || reminderDays == null) {
    return;
  }
  final now = DateTime.now();
  ref.read(reminderSchedulerProvider).sync(subscriptions, reminderDays, now);
  ref.read(widgetUpdaterProvider).sync(subscriptions, now);
});
