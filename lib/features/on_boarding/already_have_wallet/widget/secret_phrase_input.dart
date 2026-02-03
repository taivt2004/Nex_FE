import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

class SecretPhraseInput extends StatelessWidget {
  const SecretPhraseInput({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.secretPhraseLabel,
          style: TextStyle(
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Stack(
          children: [
            TextField(
              controller: controller,
              maxLines: 4,
              minLines: 3,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
              keyboardType: TextInputType.text,
              onChanged: onChanged,
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context)
                    .colorScheme
                    .surfaceContainerHighest
                    .withValues(alpha: 0.2),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: OlaColors.primarycolor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
            Positioned(
              right: 12.w,
              bottom: 8.h,
              child: GestureDetector(
                onTap: () async {
                  final data = await Clipboard.getData('text/plain');
                  final text = data?.text ?? '';
                  controller.text = text;
                  onChanged(text);
                },
                child: Text(
                  l10n.paste,
                  style: PoppinsTextStyles.primary14Regular.copyWith(
                    color: OlaColors.primarycolor,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          l10n.secretPhraseHint,
          style: PoppinsTextStyles.primary12Regular.copyWith(
            color: Theme.of(context)
                .textTheme
                .bodySmall
                ?.color
                ?.withValues(alpha: 0.7),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
