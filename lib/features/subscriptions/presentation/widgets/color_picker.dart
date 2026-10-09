// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:material_ui/material_ui.dart';

import '../subscription_palette.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final value in subscriptionPalette)
          InkResponse(
            onTap: () => onSelected(value),
            radius: 24,
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Color(value),
              child: value == selected
                  ? Icon(
                      Icons.check,
                      color:
                          ThemeData.estimateBrightnessForColor(Color(value)) ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}
