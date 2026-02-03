import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showCustomBottomSheet(
  BuildContext context, {
  required Widget body,
  Widget? title,
}) {
  showModalBottomSheet<void>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    barrierColor: Colors.black54,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
    ),
    sheetAnimationStyle: const AnimationStyle(
      duration: Duration(seconds: 1),
      reverseDuration: Duration(milliseconds: 300),
    ),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Padding(
          padding:
              MediaQuery.of(context).viewInsets, // Adjust padding for keyboard
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black12, // Start color
                      Colors.black26, // End color
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const BackButton(
                      color: Colors.white,
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: title ?? const Text(''),
                    ),
                    const SizedBox(
                      width: 80,
                    ),
                  ],
                ),
              ),
              body,
            ],
          ),
        ),
      );
    },
  );
}
