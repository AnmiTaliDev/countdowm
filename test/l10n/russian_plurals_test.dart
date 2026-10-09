// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/l10n/generated/app_localizations.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final ru = lookupAppLocalizations(const Locale('ru'));

  test('interval labels use Russian plural forms', () {
    expect(ru.everyDay, 'Каждый день');
    expect(ru.everyDays(2), 'Каждые 2 дня');
    expect(ru.everyDays(5), 'Каждые 5 дней');
    expect(ru.everyDays(21), 'Каждые 21 день');
    expect(ru.everyWeek, 'Каждую неделю');
    expect(ru.everyWeeks(3), 'Каждые 3 недели');
    expect(ru.everyMonths(6), 'Каждые 6 месяцев');
    expect(ru.everyYear, 'Каждый год');
    expect(ru.everyYears(2), 'Каждые 2 года');
    expect(ru.everyYears(5), 'Каждые 5 лет');
  });

  test('reminder labels use Russian plural forms', () {
    expect(ru.reminderDaysBefore(0), 'В день списания');
    expect(ru.reminderDaysBefore(1), 'За 1 день');
    expect(ru.reminderDaysBefore(3), 'За 3 дня');
    expect(ru.reminderDaysBefore(11), 'За 11 дней');
    expect(ru.reminderDaysBefore(22), 'За 22 дня');
  });

  test('notification and import messages use Russian plural forms', () {
    expect(
      ru.notificationBody('Видео', '5 USD', 0),
      'Видео: списание сегодня, 5 USD',
    );
    expect(
      ru.notificationBody('Видео', '5 USD', 1),
      'Видео: списание через 1 день, 5 USD',
    );
    expect(
      ru.notificationBody('Видео', '5 USD', 21),
      'Видео: списание через 21 день, 5 USD',
    );
    expect(
      ru.notificationBody('Видео', '5 USD', 2),
      'Видео: списание через 2 дня, 5 USD',
    );
    expect(
      ru.notificationBody('Видео', '5 USD', 7),
      'Видео: списание через 7 дней, 5 USD',
    );
    expect(ru.importDone(1), 'Импортирована 1 подписка');
    expect(ru.importDone(3), 'Импортировано 3 подписки');
    expect(ru.importDone(12), 'Импортировано 12 подписок');
  });

  test('English remains the fallback locale', () {
    expect(AppLocalizations.supportedLocales, contains(const Locale('en')));
    expect(AppLocalizations.supportedLocales, contains(const Locale('ru')));
    expect(
      AppLocalizations.delegate.isSupported(const Locale('ru', 'RU')),
      isTrue,
    );
    expect(AppLocalizations.delegate.isSupported(const Locale('fr')), isFalse);
  });
}
