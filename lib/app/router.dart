// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../features/settings/presentation/settings_screen.dart';
import '../features/statistics/presentation/statistics_screen.dart';
import '../features/subscriptions/presentation/subscription_form_screen.dart';
import '../features/subscriptions/presentation/subscription_list_screen.dart';
import 'home_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final rootKey = GlobalKey<NavigatorState>();
  return GoRouter(
    navigatorKey: rootKey,
    initialLocation: '/',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => HomeShell(shell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const SubscriptionListScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/statistics',
                builder: (context, state) => const StatisticsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/subscription/new',
        parentNavigatorKey: rootKey,
        builder: (context, state) => const SubscriptionFormScreen(),
      ),
      GoRoute(
        path: '/subscription/:id',
        parentNavigatorKey: rootKey,
        builder: (context, state) => SubscriptionFormScreen(
          subscriptionId: int.parse(state.pathParameters['id']!),
        ),
      ),
    ],
  );
});
