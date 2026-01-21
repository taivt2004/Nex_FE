import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

class WalletNameInput extends StatelessWidget {
  const WalletNameInput({
    required this.controller,
    this.errorText,
    this.onChanged,
    super.key,
  });
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.walletName,
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2A2A3A),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? const Color(0xFFFF3B30) : Colors.transparent,
                width: hasError ? 1.5 : 0,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError
                    ? const Color(0xFFFF3B30)
                    : OlaColors.primarycolor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFFF3B30),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFFF3B30),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            errorText: errorText,
            errorStyle: TextStyle(
              color: const Color(0xFFFF3B30),
              fontSize: 12.sp,
            ),
            suffixIcon: hasError
                ? IconButton(
                    icon: Icon(Icons.close, color: Colors.white70, size: 20.sp),
                    onPressed: () {
                      controller.clear();
                      onChanged?.call('');
                    },
                    enableFeedback: false,
                    splashRadius: 20.r,
                  )
                : IconButton(
                    icon: Icon(Icons.edit, color: Colors.white54, size: 20.sp),
                    onPressed: () {},
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    enableFeedback: false,
                    splashRadius: 20.r,
                  ),
          ),
        ),
      ],
    );
  }
}
