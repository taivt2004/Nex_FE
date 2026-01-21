import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

Future<void> showAlreadyHaveWalletSheet(
  BuildContext context, {
  required VoidCallback onContinue,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      final l10n = AppLocalizations.of(context);
      var agree1 = false;
      var agree2 = false;
      return StatefulBuilder(
        builder: (context, setState) {
          final canContinue = agree1 && agree2;
          return SafeArea(
            top: false,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1B1B27),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              ),
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 20.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        margin: EdgeInsets.only(bottom: 12.h),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ),
                    Text(
                      l10n.secretPhraseTitle,
                      style: PoppinsTextStyles.primary18Regular.copyWith(
                        color: Colors.white,
                        fontSize: 18.sp,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      l10n.secretPhraseDesc1,
                      style: PoppinsTextStyles.primary14Regular.copyWith(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      l10n.secretPhraseDesc2,
                      style: PoppinsTextStyles.primary14Regular.copyWith(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => agree1 = !agree1),
                          child: Container(
                            width: 22.w,
                            height: 22.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: agree1
                                  ? const Color(0xFF7E11D8)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: agree1
                                    ? const Color(0xFF7E11D8)
                                    : Colors.white54,
                                width: 2,
                              ),
                            ),
                            child: agree1
                                ? Icon(
                                    Icons.check,
                                    size: 16.sp,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            l10n.secretPhraseAgree1,
                            style: PoppinsTextStyles.primary12Regular.copyWith(
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () => setState(() => agree2 = !agree2),
                          child: Container(
                            width: 22.w,
                            height: 22.h,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: agree2
                                  ? const Color(0xFF7E11D8)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(6.r),
                              border: Border.all(
                                color: agree2
                                    ? const Color(0xFF7E11D8)
                                    : Colors.white54,
                                width: 2,
                              ),
                            ),
                            child: agree2
                                ? Icon(
                                    Icons.check,
                                    size: 16.sp,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            l10n.secretPhraseAgree2,
                            style: PoppinsTextStyles.primary12Regular.copyWith(
                              color: Colors.white70,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: canContinue
                          ? () {
                              Navigator.of(context).pop();
                              onContinue();
                            }
                          : null,
                      child: Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          color: canContinue
                              ? const Color(0xFF7E11D8)
                              : const Color(0xFF7E11D8).withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          l10n.continueAction,
                          style: PoppinsTextStyles.primary18Regular.copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
