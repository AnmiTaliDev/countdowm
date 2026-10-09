// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/core/format/money_format.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/sample_subscriptions.dart';
import '../../support/test_app.dart';

void main() {
  testWidgets('shows the empty state without subscriptions', (tester) async {
    await pumpTestApp(tester);
    expect(find.text('No subscriptions'), findsOneWidget);
    expect(find.text('Add subscription'), findsOneWidget);
  });

  testWidgets('lists subscriptions with countdown and the next 7 days block', (
    tester,
  ) async {
    final app = await pumpTestApp(tester);
    await seedSubscriptions(tester, app, [
      sampleSubscription(
        name: 'Soon',
        cost: 12,
        nextChargeDate: DateTime(2026, 10, 12),
      ),
      sampleSubscription(
        name: 'Later',
        cost: 30,
        nextChargeDate: DateTime(2026, 11, 20),
      ),
    ]);

    expect(find.text('Next 7 days'), findsOneWidget);
    expect(find.text('Soon'), findsNWidgets(2));
    expect(find.text('Later'), findsOneWidget);
    expect(find.text('2d 12h'), findsNWidgets(2));
    expect(find.text(formatMoney(12, 'USD')), findsOneWidget);
    expect(find.text(formatMoney(30, 'USD')), findsOneWidget);
  });

  testWidgets('sorting by price reorders the list', (tester) async {
    final app = await pumpTestApp(tester);
    await seedSubscriptions(tester, app, [
      sampleSubscription(
        name: 'Cheap',
        cost: 5,
        nextChargeDate: DateTime(2026, 10, 20),
      ),
      sampleSubscription(
        name: 'Pricey',
        cost: 50,
        nextChargeDate: DateTime(2026, 11, 20),
      ),
    ]);

    double top(String name) => tester.getTopLeft(find.text(name)).dy;
    expect(top('Cheap') < top('Pricey'), isTrue);

    await tester.tap(find.text('Price'));
    await tester.pumpAndSettle();
    expect(top('Pricey') < top('Cheap'), isTrue);
  });
}
