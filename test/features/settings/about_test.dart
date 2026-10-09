// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/app/app_license.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../support/test_app.dart';

void main() {
  testWidgets('About Countdown shows version and the license button', (
    tester,
  ) async {
    PackageInfo.setMockInitialValues(
      appName: 'Countdown',
      packageName: 'dev.anmitali.countdown',
      version: '1.2.3',
      buildNumber: '45',
      buildSignature: '',
    );
    await pumpTestApp(tester);
    await tester.tap(find.text('Settings'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('About Countdown'));
    await tester.pumpAndSettle();

    expect(find.text('1.2.3 (45)'), findsOneWidget);
    expect(
      find.text('Licensed under GPL-3.0-or-later. There is no warranty.'),
      findsOneWidget,
    );
    expect(find.text('View licenses'), findsOneWidget);
  });

  test('the application license is the GPL text', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final entries = await countdownLicense().toList();
    expect(entries.single.packages, ['Countdown']);
    final text = entries.single.paragraphs.map((p) => p.text).join('\n');
    expect(text, contains('GNU GENERAL PUBLIC LICENSE'));
  });

  test('the Material Icons license is registered with the app', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final entries = await materialIconsLicense().toList();
    expect(entries.single.packages, ['Material Icons']);
    final text = entries.single.paragraphs.map((p) => p.text).join('\n');
    expect(text, contains('Attribution 4.0 International'));
  });
}
