// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/features/subscriptions/domain/billing_period.dart';
import 'package:countdown/features/subscriptions/presentation/subscription_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import '../../support/test_app.dart';

void main() {
  testWidgets('empty form shows validation errors and saves nothing', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await tester.tap(find.text('Add subscription'));
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Required'), findsOneWidget);
    expect(find.text('Enter a number greater than 0'), findsOneWidget);
    final all = await tester.runAsync(
      () => app.container.read(subscriptionRepositoryProvider).watchAll().first,
    );
    expect(all, isEmpty);
  });

  testWidgets('valid form with custom period is saved', (tester) async {
    final app = await pumpTestApp(tester);
    await tester.tap(find.text('Add subscription'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Video');
    await tester.enterText(find.widgetWithText(TextFormField, 'Cost'), '7,5');
    await tester.tap(find.text('Custom'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Every'), '6');

    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final all = await tester.runAsync(
      () => app.container.read(subscriptionRepositoryProvider).watchAll().first,
    );
    expect(all, hasLength(1));
    expect(all!.single.name, 'Video');
    expect(all.single.cost, 7.5);
    expect(all.single.currency, 'USD');
    expect(all.single.period, const BillingPeriod(PeriodUnit.month, 6));
    expect(find.text('Video'), findsWidgets);
  });

  testWidgets('rejects a currency code shorter than three letters', (
    tester,
  ) async {
    await pumpTestApp(tester);
    await tester.tap(find.text('Add subscription'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Currency'),
      'US',
    );
    await tester.ensureVisible(find.text('Save'));
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Enter a 3-letter currency code'), findsOneWidget);
  });
}
