import 'package:flutter/material.dart';
import 'package:nexpaylab/share/utils/colors.dart';

class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect background - TO HƠN
          Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColor.onboardingIndicatorActive.withOpacity(0.3),
                  blurRadius: 120,
                  spreadRadius: 40,
                ),
              ],
            ),
          ),

          // Orbital rings image (nền - ở dưới) - CHÍNH GIỮA
          Image.asset(
            'assets/images/on_boarding2.png',
            width: 450,
            height: 450,
            fit: BoxFit.contain,
          ),

          // Main 3D coins image (đè lên trên) - TO HƠN NỮA
          Image.asset(
            'assets/images/on_boarding.png',
            width: 520,
            height: 520,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
