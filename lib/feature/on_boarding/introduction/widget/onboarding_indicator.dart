import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/share/utils/colors.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    required this.index,
    required this.currentPage,
    super.key,
  });
  final int index;
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: EdgeInsets.only(right: 8.w),
      height: 3.h,
      width: currentPage == index ? 28.w : 22.w, 
      decoration: BoxDecoration(
        color: currentPage == index
            ? AppColor
                  .onboardingIndicatorActive 
            : AppColor.onboardingIndicatorInactive, 
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }
}
