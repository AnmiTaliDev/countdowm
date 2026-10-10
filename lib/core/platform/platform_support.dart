// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:io';

bool get isPlatformSupported => !Platform.isWindows;

bool get supportsScheduledReminders => Platform.isAndroid || Platform.isIOS;

bool get supportsHomeWidget => Platform.isAndroid || Platform.isIOS;

bool get usesAppSupportDirectory => Platform.isLinux;
