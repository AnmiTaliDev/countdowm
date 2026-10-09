// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:material_ui/material_ui.dart';

class SubscriptionAvatar extends StatelessWidget {
  const SubscriptionAvatar({
    super.key,
    required this.name,
    required this.color,
  });

  final String name;
  final int color;

  @override
  Widget build(BuildContext context) {
    final background = Color(color);
    final initial = name.isEmpty ? '' : name.characters.first.toUpperCase();
    return CircleAvatar(
      backgroundColor: background,
      foregroundColor:
          ThemeData.estimateBrightnessForColor(background) == Brightness.dark
          ? Colors.white
          : Colors.black,
      child: Text(initial),
    );
  }
}
