// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:material_ui/material_ui.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/charge_schedule.dart';
import '../../domain/subscription.dart';
import '../labels.dart';
import 'subscription_avatar.dart';

class NextSevenDays extends StatelessWidget {
  const NextSevenDays({
    super.key,
    required this.subscriptions,
    required this.now,
  });

  final List<Subscription> subscriptions;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primaryContainer,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.next7Days,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            if (subscriptions.isEmpty)
              Text(
                l10n.nothingIn7Days,
                style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
              ),
            for (final subscription in subscriptions)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SubscriptionAvatar(
                      name: subscription.name,
                      color: subscription.color,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        subscription.name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    Text(
                      countdownLabel(
                        l10n,
                        countdownTo(nextCharge(subscription, now), now),
                      ),
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
