// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/format/money_format.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/charge_schedule.dart';
import '../../domain/subscription.dart';
import '../labels.dart';
import 'subscription_avatar.dart';

class SubscriptionTile extends StatelessWidget {
  const SubscriptionTile({
    super.key,
    required this.subscription,
    required this.now,
  });

  final Subscription subscription;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final countdown = countdownTo(nextCharge(subscription, now), now);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: SubscriptionAvatar(
          name: subscription.name,
          color: subscription.color,
        ),
        title: Text(subscription.name),
        subtitle: Text(
          '${categoryLabel(l10n, subscription.category)} · '
          '${periodLabel(l10n, subscription.period)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              countdownLabel(l10n, countdown),
              style: theme.textTheme.titleMedium,
            ),
            Text(
              formatMoney(subscription.cost, subscription.currency),
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
        onTap: () => context.push('/subscription/${subscription.id}'),
      ),
    );
  }
}
