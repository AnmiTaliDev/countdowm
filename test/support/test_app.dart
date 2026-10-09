// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:countdown/app/external_sync.dart';
import 'package:countdown/app/router.dart';
import 'package:countdown/core/database/app_database.dart';
import 'package:countdown/core/database/database_provider.dart';
import 'package:countdown/core/time/now_provider.dart';
import 'package:countdown/features/subscriptions/domain/subscription.dart';
import 'package:countdown/features/subscriptions/presentation/subscription_providers.dart';
import 'package:countdown/l10n/generated/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

final DateTime testNow = DateTime(2026, 10, 9, 12);

class TestApp {
  TestApp(this.database, this.container);

  final AppDatabase database;
  final ProviderContainer container;
}

Future<TestApp> pumpTestApp(WidgetTester tester, {Locale? locale}) async {
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final database = AppDatabase(NativeDatabase.memory());
  await tester.runAsync(() => database.customSelect('select 1').get());
  final container = ProviderContainer(
    overrides: [
      databaseProvider.overrideWithValue(database),
      nowProvider.overrideWith((ref) => Stream.value(testNow)),
      externalSyncProvider.overrideWith((ref) {}),
    ],
  );
  addTearDown(() async {
    container.dispose();
    await tester.runAsync(database.close);
  });
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: Consumer(
        builder: (context, ref, child) {
          return MaterialApp.router(
            locale: locale,
            routerConfig: ref.watch(routerProvider),
            localizationsDelegates: [
              AppLocalizations.delegate,
              ...GlobalMaterialLocalizations.delegates,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
  return TestApp(database, container);
}

Future<void> settleDatabase(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 100)),
  );
  await tester.pumpAndSettle();
}

Future<void> seedSubscriptions(
  WidgetTester tester,
  TestApp app,
  List<Subscription> subscriptions,
) async {
  final repository = app.container.read(subscriptionRepositoryProvider);
  await tester.runAsync(() => repository.replaceAll(subscriptions));
  await settleDatabase(tester);
}
