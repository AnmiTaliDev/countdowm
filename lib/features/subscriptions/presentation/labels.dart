// SPDX-License-Identifier: GPL-3.0-or-later

import '../../../l10n/generated/app_localizations.dart';
import '../domain/billing_period.dart';
import '../domain/charge_schedule.dart';
import '../domain/subscription_category.dart';

String categoryLabel(AppLocalizations l10n, SubscriptionCategory category) {
  return switch (category) {
    SubscriptionCategory.streaming => l10n.categoryStreaming,
    SubscriptionCategory.music => l10n.categoryMusic,
    SubscriptionCategory.software => l10n.categorySoftware,
    SubscriptionCategory.cloud => l10n.categoryCloud,
    SubscriptionCategory.gaming => l10n.categoryGaming,
    SubscriptionCategory.news => l10n.categoryNews,
    SubscriptionCategory.utilities => l10n.categoryUtilities,
    SubscriptionCategory.health => l10n.categoryHealth,
    SubscriptionCategory.other => l10n.categoryOther,
  };
}

String periodLabel(AppLocalizations l10n, BillingPeriod period) {
  final count = period.count;
  return switch (period.unit) {
    PeriodUnit.day => count == 1 ? l10n.everyDay : l10n.everyDays(count),
    PeriodUnit.week => count == 1 ? l10n.everyWeek : l10n.everyWeeks(count),
    PeriodUnit.month => count == 1 ? l10n.everyMonth : l10n.everyMonths(count),
    PeriodUnit.year => count == 1 ? l10n.everyYear : l10n.everyYears(count),
  };
}

String unitLabel(AppLocalizations l10n, PeriodUnit unit) {
  return switch (unit) {
    PeriodUnit.day => l10n.unitDay,
    PeriodUnit.week => l10n.unitWeek,
    PeriodUnit.month => l10n.unitMonth,
    PeriodUnit.year => l10n.unitYear,
  };
}

String countdownLabel(AppLocalizations l10n, Countdown countdown) {
  if (countdown.isToday) {
    return l10n.countdownToday;
  }
  return l10n.countdownDaysHours(countdown.days, countdown.hours);
}
