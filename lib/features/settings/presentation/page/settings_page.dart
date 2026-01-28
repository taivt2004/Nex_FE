import 'package:flutter/material.dart';
import 'package:nexpaylab/features/settings/widget/language_selector_bottom_sheet.dart';
import 'package:nexpaylab/features/settings/widget/theme_selector_bottom_sheet.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/ui/widget/appbar_cpn.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppbarCpn(
        title: AppLocalizations.of(context).settingsTitle,
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(AppLocalizations.of(context).theme),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (context) => const ThemeSelectorBottomSheet(),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(AppLocalizations.of(context).language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (context) => const LanguageSelectorBottomSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}
