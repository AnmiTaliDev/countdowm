// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/database_provider.dart';
import '../data/subscription_repository.dart';
import '../domain/subscription.dart';
import '../domain/subscription_sort.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(ref.watch(databaseProvider));
});

final subscriptionsProvider = StreamProvider<List<Subscription>>((ref) {
  return ref.watch(subscriptionRepositoryProvider).watchAll();
});

final subscriptionByIdProvider = FutureProvider.family<Subscription?, int>((
  ref,
  id,
) {
  return ref.watch(subscriptionRepositoryProvider).findById(id);
});

class SortOrderNotifier extends Notifier<SortOrder> {
  @override
  SortOrder build() => SortOrder.date;

  void select(SortOrder order) {
    state = order;
  }
}

final sortOrderProvider = NotifierProvider<SortOrderNotifier, SortOrder>(
  SortOrderNotifier.new,
);
