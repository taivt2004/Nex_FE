import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/language/language_model.dart';
import 'package:provider/provider.dart';
class LanguageSelectorBottomSheet extends StatelessWidget {
  const LanguageSelectorBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final languageModel = Provider.of<LanguageModel>(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLocalizations.of(context).selectLanguage,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          SizedBox(height: 16.h),
          _buildOption(
            context,
            title: 'English',
            code: 'en',
            isSelected: languageModel.currentLocale?.languageCode == 'en',
            onTap: () => languageModel.setLocale('en'),
          ),
          _buildOption(
            context,
            title: 'Tiếng Việt',
            code: 'vi',
            isSelected: languageModel.currentLocale?.languageCode == 'vi',
            onTap: () => languageModel.setLocale('vi'),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String title,
    required String code,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Text(
        code.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Theme.of(context).primaryColor : null,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).primaryColor)
          : null,
      onTap: () {
        onTap();
        Navigator.pop(context);
      },
    );
  }
}
