// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../backup/presentation/backup_actions.dart';
import '../../notifications/domain/reminder_plan.dart';
import 'about_tile.dart';
import 'settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final days = ref.watch(reminderDaysProvider).value;
    final settings = ref.read(settingsRepositoryProvider);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navSettings)),
      body: ListView(
        children: [
          ListTile(
            title: Text(l10n.settingsReminder),
            subtitle: days == null ? null : Text(l10n.reminderDaysBefore(days)),
            trailing: days == null
                ? null
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: days > 0
                            ? () => settings.setReminderDays(days - 1)
                            : null,
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: days < maxReminderDays
                            ? () => settings.setReminderDays(days + 1)
                            : null,
                      ),
                    ],
                  ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Text(l10n.settingsData, style: theme.textTheme.titleMedium),
          ),
          const BackupActions(),
          const Divider(),
          const AboutTile(),
        ],
      ),
    );
  }
}
