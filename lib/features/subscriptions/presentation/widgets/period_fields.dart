// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../l10n/generated/app_localizations.dart';
import '../../domain/billing_period.dart';
import '../labels.dart';

enum PeriodChoice { week, month, year, custom }

PeriodChoice choiceFor(BillingPeriod period) {
  if (period.count == 1) {
    switch (period.unit) {
      case PeriodUnit.week:
        return PeriodChoice.week;
      case PeriodUnit.month:
        return PeriodChoice.month;
      case PeriodUnit.year:
        return PeriodChoice.year;
      case PeriodUnit.day:
        return PeriodChoice.custom;
    }
  }
  return PeriodChoice.custom;
}

BillingPeriod? periodFor(PeriodChoice choice) {
  return switch (choice) {
    PeriodChoice.week => const BillingPeriod(PeriodUnit.week, 1),
    PeriodChoice.month => const BillingPeriod(PeriodUnit.month, 1),
    PeriodChoice.year => const BillingPeriod(PeriodUnit.year, 1),
    PeriodChoice.custom => null,
  };
}

class PeriodFields extends StatelessWidget {
  const PeriodFields({
    super.key,
    required this.choice,
    required this.unit,
    required this.countController,
    required this.onChoiceChanged,
    required this.onUnitChanged,
  });

  final PeriodChoice choice;
  final PeriodUnit unit;
  final TextEditingController countController;
  final ValueChanged<PeriodChoice> onChoiceChanged;
  final ValueChanged<PeriodUnit> onUnitChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.fieldPeriod, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        SegmentedButton<PeriodChoice>(
          showSelectedIcon: false,
          segments: [
            ButtonSegment(
              value: PeriodChoice.week,
              label: Text(l10n.periodWeek),
            ),
            ButtonSegment(
              value: PeriodChoice.month,
              label: Text(l10n.periodMonth),
            ),
            ButtonSegment(
              value: PeriodChoice.year,
              label: Text(l10n.periodYear),
            ),
            ButtonSegment(
              value: PeriodChoice.custom,
              label: Text(l10n.periodCustom),
            ),
          ],
          selected: {choice},
          onSelectionChanged: (selection) => onChoiceChanged(selection.first),
        ),
        if (choice == PeriodChoice.custom) ...[
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: countController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(labelText: l10n.fieldInterval),
                  validator: (value) {
                    final count = int.tryParse(value ?? '');
                    return count == null || count < 1
                        ? l10n.errorInterval
                        : null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<PeriodUnit>(
                  initialValue: unit,
                  decoration: InputDecoration(
                    labelText: l10n.fieldIntervalUnit,
                  ),
                  items: [
                    for (final value in PeriodUnit.values)
                      DropdownMenuItem(
                        value: value,
                        child: Text(unitLabel(l10n, value)),
                      ),
                  ],
                  onChanged: (value) => onUnitChanged(value!),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
