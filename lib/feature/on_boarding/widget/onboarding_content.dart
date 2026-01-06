import 'package:flutter/material.dart';
import 'package:nexpaylab/share/theme/app_style.dart';

class OnboardingContent extends StatelessWidget {
  const OnboardingContent({required this.title, required this.desc, super.key});
  final String title;
  final String desc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: KoHoTextStyles.display36Medium.copyWith(
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: OlaTextStyles.primarytext14regular.copyWith(
              color: Colors.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
