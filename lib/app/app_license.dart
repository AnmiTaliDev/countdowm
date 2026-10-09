// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

Stream<LicenseEntry> countdownLicense() async* {
  final text = await rootBundle.loadString('LICENSE');
  yield LicenseEntryWithLineBreaks(['Countdown'], text);
}

Stream<LicenseEntry> materialIconsLicense() async* {
  final text = await rootBundle.loadString(
    'assets/licenses/MaterialIcons_LICENSE.txt',
  );
  yield LicenseEntryWithLineBreaks(['Material Icons'], text);
}
