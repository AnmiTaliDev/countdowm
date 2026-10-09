// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/features/settings/presentation/settings_providers.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../support/test_app.dart';

void main() {
  testWidgets('changes the global reminder days', (tester) async {
    final app = await pumpTestApp(tester);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();

    expect(find.text('3 days before'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('4 days before'), findsOneWidget);

    final days = await tester.runAsync(
      () => app.container.read(settingsRepositoryProvider).reminderDays(),
    );
    expect(days, 4);
  });
}
