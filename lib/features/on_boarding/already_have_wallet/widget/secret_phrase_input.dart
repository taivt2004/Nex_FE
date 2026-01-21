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
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
        ),
        SizedBox(height: 10.h),
        Stack(
          children: [
            TextField(
              controller: controller,
              maxLines: 4,
              minLines: 3,
              style: const TextStyle(color: Colors.white),
              keyboardType: TextInputType.text,
              onChanged: onChanged,
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF2A2A3A),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 16.h,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 0,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
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
            color: Colors.white54,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
