// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/app/unsupported_platform_app.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the unsupported platform message in English', (
    tester,
  ) async {
    await tester.pumpWidget(const UnsupportedPlatformApp());
    await tester.pumpAndSettle();
    expect(find.text('Platform not supported'), findsOneWidget);
    expect(find.textContaining('WSL'), findsOneWidget);
  });

  testWidgets('shows the unsupported platform message in Russian', (
    tester,
  ) async {
    tester.platformDispatcher.localesTestValue = const [Locale('ru')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    await tester.pumpWidget(const UnsupportedPlatformApp());
    await tester.pumpAndSettle();
    expect(find.text('Платформа не поддерживается'), findsOneWidget);
    expect(find.textContaining('WSL'), findsOneWidget);
  });
}
