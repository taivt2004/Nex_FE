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
          style: TextStyle(
            color:
                Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: controller,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
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
                color: hasError
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).dividerColor,
                width: hasError ? 1.5 : 1,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError
                    ? Theme.of(context).colorScheme.error
                    : OlaColors.primarycolor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            errorText: errorText,
            errorStyle: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontSize: 12.sp,
            ),
            suffixIcon: hasError
                ? IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Theme.of(context)
                          .iconTheme
                          .color
                          ?.withValues(alpha: 0.7),
                      size: 20.sp,
                    ),
                    onPressed: () {
                      controller.clear();
                      onChanged?.call('');
                    },
                    enableFeedback: false,
                    splashRadius: 20.r,
                  )
                : IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: Theme.of(context)
                          .iconTheme
                          .color
                          ?.withValues(alpha: 0.6),
                      size: 20.sp,
                    ),
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
