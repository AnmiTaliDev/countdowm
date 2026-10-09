// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:ui';

import 'generated/app_localizations.dart';

AppLocalizations systemLocalizations() {
  final locale = PlatformDispatcher.instance.locale;
  final supported = AppLocalizations.delegate.isSupported(locale);
  return lookupAppLocalizations(supported ? locale : const Locale('en'));
}
