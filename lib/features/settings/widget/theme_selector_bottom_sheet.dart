import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';
import 'package:nexpaylab/shared/theme/theme_mode.dart';
import 'package:provider/provider.dart';

class ThemeSelectorBottomSheet extends StatelessWidget {
  const ThemeSelectorBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the ThemeModel from the Provider (already wrapped in the root of the App).
    final themeModel = Provider.of<ThemeModel>(context);
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.all(16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.theme,
            style: PoppinsTextStyles.display16Medium,
          ),
          SizedBox(height: 16.h),
          _buildOption(
            context,
            title: l10n.lightTheme,
            icon: Icons.light_mode,
            isSelected: themeModel.themeMode == ThemeMode.light,
            onTap: () => themeModel.setTheme(ThemeMode.light),
          ),
          _buildOption(
            context,
            title: l10n.darkTheme,
            icon: Icons.dark_mode,
            isSelected: themeModel.themeMode == ThemeMode.dark,
            onTap: () => themeModel.setTheme(ThemeMode.dark),
          ),
          _buildOption(
            context,
            title: l10n.systemTheme,
            icon: Icons.settings_brightness,
            isSelected: themeModel.themeMode == ThemeMode.system,
            onTap: () => themeModel.setTheme(ThemeMode.system),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildOption(
    BuildContext context, {
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? Theme.of(context).primaryColor : null,
      ),
      title: Text(
        title,
        style: PoppinsTextStyles.display16Medium.copyWith(
          color: isSelected ? Theme.of(context).primaryColor : null,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check, color: Theme.of(context).primaryColor)
          : null,
      onTap: () {
        onTap();
        Navigator.pop(context); // Đóng bottom sheet sau khi chọn
      },
    );
  }
}
