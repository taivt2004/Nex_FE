import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/shared/utils/colors.dart';

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect background - TO HƠN
          Container(
            width: 350.w,
            height: 350.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color:
                      AppColor.onboardingIndicatorActive.withValues(alpha: 0.3),
                  blurRadius: 120.r,
                  spreadRadius: 40.r,
                ),
              ],
            ),
          ),

          // Orbital rings image (nền - ở dưới) - CHÍNH GIỮA
          Image.asset(
            'assets/images/on_boarding2.png',
            width: 450.w,
            height: 450.h,
            fit: BoxFit.contain,
          ),

          // Main 3D coins image (đè lên trên) - TO HƠN NỮA
          Image.asset(
            'assets/images/on_boarding.png',
            width: 520.w,
            height: 520.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
