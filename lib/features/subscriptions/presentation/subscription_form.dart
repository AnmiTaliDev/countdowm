// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../notifications/domain/reminder_plan.dart';
import '../../settings/presentation/settings_providers.dart';
import '../domain/billing_period.dart';
import '../domain/charge_schedule.dart';
import '../domain/subscription.dart';
import '../domain/subscription_category.dart';
import 'labels.dart';
import 'subscription_palette.dart';
import 'subscription_providers.dart';
import 'widgets/color_picker.dart';
import 'widgets/period_fields.dart';

class SubscriptionForm extends ConsumerStatefulWidget {
  const SubscriptionForm({super.key, this.initial});

  final Subscription? initial;

  @override
  ConsumerState<SubscriptionForm> createState() => _SubscriptionFormState();
}

class _SubscriptionFormState extends ConsumerState<SubscriptionForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _cost;
  late final TextEditingController _currency;
  late final TextEditingController _count;
  late final TextEditingController _note;
  late final TextEditingController _url;
  late PeriodChoice _choice;
  late PeriodUnit _unit;
  late DateTime _date;
  late SubscriptionCategory _category;
  late int _color;
  late bool _useDefaultReminder;
  late int _reminderDays;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _name = TextEditingController(text: initial?.name ?? '');
    _cost = TextEditingController(
      text: initial == null ? '' : _plain(initial.cost),
    );
    _currency = TextEditingController(text: initial?.currency ?? 'USD');
    _count = TextEditingController(text: '${initial?.period.count ?? 1}');
    _note = TextEditingController(text: initial?.note ?? '');
    _url = TextEditingController(text: initial?.serviceUrl ?? '');
    _choice = initial == null ? PeriodChoice.month : choiceFor(initial.period);
    _unit = initial?.period.unit ?? PeriodUnit.month;
    _date = initial == null
        ? dateOnly(DateTime.now())
        : nextCharge(initial, DateTime.now());
    _category = initial?.category ?? SubscriptionCategory.other;
    _color = initial?.color ?? subscriptionPalette.first;
    _useDefaultReminder = initial?.reminderDays == null;
    _reminderDays = initial?.reminderDays ?? 3;
  }

  @override
  void dispose() {
    _name.dispose();
    _cost.dispose();
    _currency.dispose();
    _count.dispose();
    _note.dispose();
    _url.dispose();
    super.dispose();
  }

  String _plain(double value) {
    return value == value.roundToDouble()
        ? value.toStringAsFixed(0)
        : value.toString();
  }

  BillingPeriod _period() {
    return periodFor(_choice) ?? BillingPeriod(_unit, int.parse(_count.text));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => _date = dateOnly(picked));
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final subscription = Subscription(
      id: widget.initial?.id,
      name: _name.text.trim(),
      cost: double.parse(_cost.text.replaceAll(',', '.')),
      currency: _currency.text.toUpperCase(),
      period: _period(),
      nextChargeDate: _date,
      category: _category,
      note: _note.text.trim(),
      serviceUrl: _url.text.trim(),
      color: _color,
      reminderDays: _useDefaultReminder ? null : _reminderDays,
    );
    await ref.read(subscriptionRepositoryProvider).save(subscription);
    if (mounted) {
      context.pop();
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteTitle),
        content: Text(l10n.deleteBody(widget.initial!.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await ref.read(subscriptionRepositoryProvider).delete(widget.initial!.id!);
    if (mounted) {
      context.pop();
    }
  }

  String? _validateUrl(String? value, AppLocalizations l10n) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(text);
    final valid =
        uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
    return valid ? null : l10n.errorUrl;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final defaultDays = ref.watch(reminderDaysProvider).value;
    final editing = widget.initial != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? l10n.editSubscription : l10n.addSubscription),
        actions: [
          if (editing)
            IconButton(
              tooltip: l10n.delete,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l10n.fieldName),
              validator: (value) => value == null || value.trim().isEmpty
                  ? l10n.errorRequired
                  : null,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: _cost,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(labelText: l10n.fieldCost),
                    validator: (value) {
                      final cost = double.tryParse(
                        (value ?? '').replaceAll(',', '.'),
                      );
                      return cost == null || cost <= 0
                          ? l10n.errorNumber
                          : null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _currency,
                    textCapitalization: TextCapitalization.characters,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(3),
                      FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]')),
                    ],
                    decoration: InputDecoration(labelText: l10n.fieldCurrency),
                    validator: (value) =>
                        (value ?? '').length == 3 ? null : l10n.errorCurrency,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            PeriodFields(
              choice: _choice,
              unit: _unit,
              countController: _count,
              onChoiceChanged: (value) => setState(() => _choice = value),
              onUnitChanged: (value) => setState(() => _unit = value),
            ),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.fieldNextCharge),
              subtitle: Text(DateFormat.yMMMd(locale).format(_date)),
              trailing: const Icon(Icons.calendar_today_outlined),
              onTap: _pickDate,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<SubscriptionCategory>(
              initialValue: _category,
              decoration: InputDecoration(labelText: l10n.fieldCategory),
              items: [
                for (final value in SubscriptionCategory.values)
                  DropdownMenuItem(
                    value: value,
                    child: Text(categoryLabel(l10n, value)),
                  ),
              ],
              onChanged: (value) => setState(() => _category = value!),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.fieldColor,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 8),
            ColorPicker(
              selected: _color,
              onSelected: (value) => setState(() => _color = value),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.reminderUseDefault),
              subtitle: defaultDays == null
                  ? null
                  : Text(l10n.reminderDaysBefore(defaultDays)),
              value: _useDefaultReminder,
              onChanged: (value) => setState(() => _useDefaultReminder = value),
            ),
            if (!_useDefaultReminder) ...[
              Text(l10n.reminderDaysBefore(_reminderDays)),
              Slider(
                value: _reminderDays.toDouble(),
                min: 0,
                max: maxReminderDays.toDouble(),
                divisions: maxReminderDays,
                label: '$_reminderDays',
                onChanged: (value) =>
                    setState(() => _reminderDays = value.round()),
              ),
            ],
            const SizedBox(height: 8),
            TextFormField(
              controller: _note,
              maxLines: 3,
              minLines: 1,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: l10n.fieldNote),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _url,
              keyboardType: TextInputType.url,
              decoration: InputDecoration(labelText: l10n.fieldUrl),
              validator: (value) => _validateUrl(value, l10n),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: Text(l10n.save)),
          ],
        ),
      ),
    );
  }
}
