// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/app_license.dart';
import 'app/unsupported_platform_app.dart';
import 'core/platform/platform_support.dart';

void main() {
  if (!isPlatformSupported) {
    runApp(const UnsupportedPlatformApp());
    return;
  }
  LicenseRegistry.addLicense(countdownLicense);
  LicenseRegistry.addLicense(materialIconsLicense);
  runApp(const ProviderScope(child: CountdownApp()));
}
