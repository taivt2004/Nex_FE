import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/shared/ui/widget/appbar_cpn.dart';

class OnboardingScaffold extends StatelessWidget {
  const OnboardingScaffold({
    required this.title,
    required this.body,
    super.key,
    this.bottomButton,
    this.backgroundColor = const Color(0xFF121314),
  });

  final String title;
  final Widget body;
  final Widget? bottomButton;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppbarCpn(
        title: title,
        backgroundColor: backgroundColor,
      ),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(20.r),
                child: body,
              ),
            ),
            if (bottomButton != null)
              Container(
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: bottomButton,
              ),
          ],
        ),
      ),
    );
  }
}
