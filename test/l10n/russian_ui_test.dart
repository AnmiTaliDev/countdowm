// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/sample_subscriptions.dart';
import '../support/test_app.dart';

void main() {
  testWidgets('list, navigation and form render in Russian', (tester) async {
    final app = await pumpTestApp(tester, locale: const Locale('ru'));
    expect(find.text('Подписок нет'), findsOneWidget);
    expect(find.text('Статистика'), findsOneWidget);
    expect(find.text('Настройки'), findsOneWidget);

    await seedSubscriptions(tester, app, [
      sampleSubscription(name: 'Видео', nextChargeDate: DateTime(2026, 10, 12)),
    ]);
    expect(find.text('Ближайшие 7 дней'), findsOneWidget);
    expect(find.textContaining('Каждый месяц'), findsOneWidget);
    expect(find.text('2 д 12 ч'), findsNWidgets(2));

    await tester.tap(find.text('Добавить подписку'));
    await tester.pumpAndSettle();
    expect(find.text('Следующее списание'), findsOneWidget);
    expect(find.text('Название'), findsOneWidget);
  });

  testWidgets('settings and About render in Russian', (tester) async {
    await pumpTestApp(tester, locale: const Locale('ru'));
    await tester.tap(find.text('Настройки'));
    await tester.pumpAndSettle();
    expect(find.text('За 3 дня'), findsOneWidget);
    expect(find.text('Экспорт в JSON'), findsOneWidget);
    expect(find.text('О приложении Countdown'), findsOneWidget);
  });
}
