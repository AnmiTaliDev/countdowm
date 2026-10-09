// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:ui';

import 'package:intl/intl.dart';

String formatMoney(double amount, String currency) {
  final locale = PlatformDispatcher.instance.locale.toString();
  return NumberFormat.currency(locale: locale, name: currency).format(amount);
}
