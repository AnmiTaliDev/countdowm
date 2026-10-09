// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../core/time/now_provider.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/charge_schedule.dart';
import '../domain/subscription_sort.dart';
import 'subscription_providers.dart';
import 'widgets/next_seven_days.dart';
import 'widgets/subscription_tile.dart';

class SubscriptionListScreen extends ConsumerWidget {
  const SubscriptionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final subscriptions = ref.watch(subscriptionsProvider).value;
    final now = ref.watch(nowProvider).value;
    final order = ref.watch(sortOrderProvider);

    final Widget body;
    if (subscriptions == null || now == null) {
      body = const Center(child: CircularProgressIndicator());
    } else if (subscriptions.isEmpty) {
      body = _EmptyState(title: l10n.emptyTitle, body: l10n.emptyBody);
    } else {
      final soon = sortSubscriptions(
        subscriptions.where((item) => chargesWithinDays(item, now, 7)).toList(),
        SortOrder.date,
        now,
      );
      final sorted = sortSubscriptions(subscriptions, order, now);
      body = ListView(
        padding: const EdgeInsets.only(bottom: 96),
        children: [
          NextSevenDays(subscriptions: soon, now: now),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: SegmentedButton<SortOrder>(
              showSelectedIcon: false,
              segments: [
                ButtonSegment(
                  value: SortOrder.date,
                  label: Text(l10n.sortDate),
                ),
                ButtonSegment(
                  value: SortOrder.price,
                  label: Text(l10n.sortPrice),
                ),
                ButtonSegment(
                  value: SortOrder.category,
                  label: Text(l10n.sortCategory),
                ),
              ],
              selected: {order},
              onSelectionChanged: (selection) {
                ref.read(sortOrderProvider.notifier).select(selection.first);
              },
            ),
          ),
          for (final subscription in sorted)
            SubscriptionTile(subscription: subscription, now: now),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.appTitle)),
      body: body,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/subscription/new'),
        icon: const Icon(Icons.add),
        label: Text(l10n.addSubscription),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(body, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
