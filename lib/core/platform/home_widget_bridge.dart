// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:home_widget/home_widget.dart';

const String widgetAppGroupId = 'group.dev.anmitali.countdown';
const String androidWidgetProvider = 'CountdownWidgetProvider';
const String iosWidgetKind = 'CountdownWidget';

class HomeWidgetBridge {
  bool _groupConfigured = false;

  Future<void> show({
    required String? name,
    required String? cost,
    required int? chargeMillis,
  }) async {
    if (!_groupConfigured) {
      await HomeWidget.setAppGroupId(widgetAppGroupId);
      _groupConfigured = true;
    }
    await HomeWidget.saveWidgetData<String>('next_name', name);
    await HomeWidget.saveWidgetData<String>('next_cost', cost);
    await HomeWidget.saveWidgetData<String>(
      'next_charge_millis',
      chargeMillis?.toString(),
    );
    await HomeWidget.updateWidget(
      androidName: androidWidgetProvider,
      iOSName: iosWidgetKind,
    );
  }
}
