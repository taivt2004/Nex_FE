import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';
import 'package:nexpaylab/shared/utils/colors.dart';

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({super.key});
  
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Text.rich(
        TextSpan(
          text: l10n.termsOfServiceConsent,
          style: PoppinsTextStyles.primary12Regular.copyWith(
            color: Colors.white.withValues(alpha: 0.3),
          ),
          children: [
            TextSpan(
              text: l10n.termsOfService,
              style: PoppinsTextStyles.primary12Regular.copyWith(
                color: AppColor.onboardingTermsText,
              ),
            ),
            TextSpan(text: l10n.and),
            TextSpan(
              text: l10n.privacyPolicy,
              style: PoppinsTextStyles.primary12Regular.copyWith(
                color: AppColor.onboardingTermsText,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
