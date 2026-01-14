import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/share/theme/app_style.dart';
import 'package:nexpaylab/share/utils/colors.dart';

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Text.rich(
        TextSpan(
          text: 'By tapping above button, you agree and consent to our ',
          style: PoppinsTextStyles.primary12Regular.copyWith(
            color: Colors.white.withValues(alpha: 0.3),
          ),
          children: [
            TextSpan(
              text: 'Terms of Service',
              style: PoppinsTextStyles.primary12Regular.copyWith(
                color: AppColor.onboardingTermsText,
              ),
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
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
