// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:ui';

import '../../../core/format/money_format.dart';
import '../../../core/platform/local_notifications.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../subscriptions/domain/subscription.dart';
import '../domain/reminder_plan.dart';

class ReminderScheduler {
  ReminderScheduler(this._notifications);

  final LocalNotifications _notifications;

  Future<void> sync(
    List<Subscription> subscriptions,
    int defaultDays,
    DateTime now,
  ) {
    final locale = PlatformDispatcher.instance.locale;
    final supported = AppLocalizations.delegate.isSupported(locale);
    final strings = lookupAppLocalizations(
      supported ? locale : const Locale('en'),
    );
    final reminders = planReminders(subscriptions, defaultDays, now);
    return _notifications.replaceAll(
      [
        for (final reminder in reminders)
          ScheduledNotification(
            id: reminder.id,
            fireAt: reminder.fireAt,
            title: strings.notificationTitle,
            body: strings.notificationBody(
              reminder.subscription.name,
              formatMoney(
                reminder.subscription.cost,
                reminder.subscription.currency,
              ),
              reminder.daysBefore,
            ),
          ),
      ],
      channelName: strings.notificationChannelName,
      channelDescription: strings.notificationChannelDescription,
    );
  }
}
