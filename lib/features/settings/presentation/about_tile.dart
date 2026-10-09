// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:material_ui/material_ui.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../l10n/generated/app_localizations.dart';

class AboutTile extends StatelessWidget {
  const AboutTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: Text(l10n.aboutTitle),
      onTap: () => _showAbout(context),
    );
  }

  Future<void> _showAbout(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final info = await PackageInfo.fromPlatform();
    if (!context.mounted) {
      return;
    }
    showAboutDialog(
      context: context,
      applicationName: l10n.appTitle,
      applicationVersion: l10n.aboutVersion(info.version, info.buildNumber),
      applicationLegalese: l10n.aboutLegalese,
      applicationIcon: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset('assets/icon/icon.png', width: 48, height: 48),
      ),
      children: [const SizedBox(height: 16), Text(l10n.aboutDescription)],
    );
  }
}
