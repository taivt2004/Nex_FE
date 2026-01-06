import 'package:flutter/material.dart';
import 'package:nexpaylab/share/utils/colors.dart';

class OnboardingIndicator extends StatelessWidget {
  final int index;
  final int currentPage;

  const OnboardingIndicator({
    super.key,
    required this.index,
    required this.currentPage,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 8),
      height: 3,
      width: currentPage == index ? 28 : 22, // Dài ra khi active
      decoration: BoxDecoration(
        color: currentPage == index
            ? AppColor.onboardingIndicatorActive // Màu tím active
            : AppColor.onboardingIndicatorInactive, // Màu xám inactive
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
