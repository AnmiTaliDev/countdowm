// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../domain/statistics.dart';
import 'statistics_providers.dart';
import 'widgets/currency_statistics_section.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final List<CurrencyStatistics> statistics = ref.watch(statisticsProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navStatistics)),
      body: statistics.isEmpty
          ? Center(child: Text(l10n.statsEmpty))
          : ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                for (final item in statistics)
                  CurrencyStatisticsSection(statistics: item),
              ],
            ),
    );
  }
}
