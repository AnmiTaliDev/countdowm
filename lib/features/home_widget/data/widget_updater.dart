// SPDX-License-Identifier: GPL-3.0-or-later

import '../../../core/format/money_format.dart';
import '../../../core/platform/home_widget_bridge.dart';
import '../../../l10n/system_localizations.dart';
import '../../subscriptions/domain/subscription.dart';
import '../domain/next_charge_snapshot.dart';

class WidgetUpdater {
  WidgetUpdater(this._bridge);

  final HomeWidgetBridge _bridge;

  Future<void> sync(List<Subscription> subscriptions, DateTime now) {
    final emptyText = systemLocalizations().emptyTitle;
    final nearest = nearestCharge(subscriptions, now);
    if (nearest == null) {
      return _bridge.show(
        name: null,
        cost: null,
        chargeMillis: null,
        emptyText: emptyText,
      );
    }
    final subscription = nearest.subscription;
    return _bridge.show(
      name: subscription.name,
      cost: formatMoney(subscription.cost, subscription.currency),
      chargeMillis: nearest.date.millisecondsSinceEpoch,
      emptyText: emptyText,
    );
  }
}
