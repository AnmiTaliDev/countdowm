// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../data/backup_service.dart';
import '../domain/backup_data.dart';
import 'backup_providers.dart';

class BackupActions extends ConsumerWidget {
  const BackupActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final service = ref.watch(backupServiceProvider);
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.data_object),
          title: Text(l10n.exportJson),
          onTap: () => _export(context, service.exportJson),
        ),
        ListTile(
          leading: const Icon(Icons.table_chart_outlined),
          title: Text(l10n.exportCsv),
          onTap: () => _export(context, service.exportCsv),
        ),
        ListTile(
          leading: const Icon(Icons.file_open_outlined),
          title: Text(l10n.importFile),
          onTap: () => _import(context, service),
        ),
      ],
    );
  }

  Future<void> _export(
    BuildContext context,
    Future<bool> Function(DateTime now) action,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final message = AppLocalizations.of(context).exportDone;
    final saved = await action(DateTime.now());
    if (saved) {
      messenger.showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Future<void> _import(BuildContext context, BackupService service) async {
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context);
    final BackupData? data;
    try {
      data = await service.pickImport();
    } on FormatException {
      messenger.showSnackBar(SnackBar(content: Text(l10n.importFailed)));
      return;
    }
    if (data == null || !context.mounted) {
      return;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.importConfirmTitle),
        content: Text(l10n.importConfirmBody(data!.subscriptions.length)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.importConfirm),
          ),
        ],
      ),
    );
    if (confirmed != true) {
      return;
    }
    await service.applyImport(data);
    messenger.showSnackBar(
      SnackBar(content: Text(l10n.importDone(data.subscriptions.length))),
    );
  }
}
