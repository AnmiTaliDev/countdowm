// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:math';

import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/format/money_format.dart';
import '../../../../l10n/generated/app_localizations.dart';
import '../../../subscriptions/presentation/labels.dart';
import '../../domain/statistics.dart';
import 'bar_row.dart';

class CurrencyStatisticsSection extends StatelessWidget {
  const CurrencyStatisticsSection({super.key, required this.statistics});

  final CurrencyStatistics statistics;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();
    final currency = statistics.currency;

    final categories = statistics.byCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final maxCategory = categories.map((entry) => entry.value).fold(0.0, max);
    final maxMonth = statistics.byMonth
        .map((item) => item.total)
        .fold(0.0, max);

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(currency, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 16),
            Text(l10n.statsByCategory, style: theme.textTheme.titleLarge),
            Text(l10n.statsByCategoryNote, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            for (final entry in categories)
              BarRow(
                label: categoryLabel(l10n, entry.key),
                amount: formatMoney(entry.value, currency),
                ratio: maxCategory == 0 ? 0 : entry.value / maxCategory,
              ),
            const SizedBox(height: 16),
            Text(l10n.statsByMonth, style: theme.textTheme.titleLarge),
            Text(l10n.statsByMonthNote, style: theme.textTheme.bodySmall),
            const SizedBox(height: 8),
            for (final item in statistics.byMonth)
              BarRow(
                label: DateFormat.yMMM(locale).format(item.month),
                amount: formatMoney(item.total, currency),
                ratio: maxMonth == 0 ? 0 : item.total / maxMonth,
              ),
          ],
        ),
      ),
    );
  }
}
