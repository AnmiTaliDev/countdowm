// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/time/now_provider.dart';
import '../../subscriptions/presentation/subscription_providers.dart';
import '../domain/statistics.dart';

final statisticsProvider = Provider<List<CurrencyStatistics>>((ref) {
  final subscriptions = ref.watch(subscriptionsProvider).value ?? const [];
  final now = ref.watch(nowProvider).value ?? DateTime.now();
  return computeStatistics(subscriptions, now);
});
