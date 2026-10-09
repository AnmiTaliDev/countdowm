// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../domain/subscription.dart';
import 'subscription_form.dart';
import 'subscription_providers.dart';

class SubscriptionFormScreen extends ConsumerWidget {
  const SubscriptionFormScreen({super.key, this.subscriptionId});

  final int? subscriptionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final id = subscriptionId;
    if (id == null) {
      return const SubscriptionForm();
    }
    return switch (ref.watch(subscriptionByIdProvider(id))) {
      AsyncData<Subscription?>(:final value) => SubscriptionForm(
        initial: value,
      ),
      _ => const Scaffold(body: Center(child: CircularProgressIndicator())),
    };
  }
}
