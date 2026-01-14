import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/share/theme/app_style.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({required this.title, required this.desc, super.key});
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: KoHoTextStyles.display36Medium.copyWith(
                color: Colors.white,
                height: 1.2,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              desc,
              textAlign: TextAlign.center,
              style: OlaTextStyles.primarytext14regular.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
