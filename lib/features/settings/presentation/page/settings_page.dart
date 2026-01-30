import 'package:flutter/material.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/language/language_model.dart';
import 'package:nexpaylab/shared/theme/theme_mode.dart';
import 'package:nexpaylab/shared/ui/widget/appbar_cpn.dart';
import 'package:nexpaylab/shared/ui/widget/toast/generic_selection_bottom_sheet.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final themeModel = Provider.of<ThemeModel>(context);
    final languageModel = Provider.of<LanguageModel>(context);

    
    final supportedLanguages = [
      {'code': 'en', 'name': l10n.english},
      {'code': 'vi', 'name': l10n.vietnamese},
    ];

    
    final themeOptions = [
      {'mode': ThemeMode.light, 'name': l10n.lightTheme, 'icon': Icons.light_mode},
      {'mode': ThemeMode.dark, 'name': l10n.darkTheme, 'icon': Icons.dark_mode},
      {'mode': ThemeMode.system, 'name': l10n.systemTheme, 'icon': Icons.settings_brightness},
    ];

    return Scaffold(
      appBar: AppbarCpn(
        title: l10n.settingsTitle,
      ),
      body: ListView(
        children: [
          // 1. Theme Selector
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.theme),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Tìm option hiện tại dựa trên themeMode đang active
              final currentOption = themeOptions.firstWhere(
                (t) => t['mode'] == themeModel.themeMode,
                orElse: () => themeOptions.last,
              );

              showModalBottomSheet<void>(
                context: context,
                builder: (_) => GenericSelectionBottomSheet<Map<String, dynamic>>(
                  title: l10n.theme,
                  options: themeOptions,
                  selectedValue: currentOption,
                  onChanged: (selected) {
                    themeModel.setTheme(selected['mode'] as ThemeMode);
                  },
                  labelBuilder: (item) => item['name'] as String,
                  iconBuilder: (item) => item['icon'] as IconData,
                ),
              );
            },
          ),
          
          const Divider(height: 1),

          // 2. Language Selector
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Tìm option hiện tại dựa trên locale code
              final currentOption = supportedLanguages.firstWhere(
                (lang) => lang['code'] == languageModel.currentLocale?.languageCode,
                orElse: () => supportedLanguages.first,
              );

              showModalBottomSheet<void>(
                context: context,
                builder: (_) => GenericSelectionBottomSheet<Map<String, String>>(
                  title: l10n.selectLanguage,
                  options: supportedLanguages,
                  selectedValue: currentOption,
                  onChanged: (selected) {
                    languageModel.setLocale(selected['code']!);
                  },
                  labelBuilder: (item) => item['name']!,
                  // Không cần iconBuilder
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
