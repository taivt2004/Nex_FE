import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Dimension {
  static final horizontalPadding = EdgeInsets.symmetric(
    horizontal: 16.w,
  );
  static final verticalPadding = EdgeInsets.symmetric(
    vertical: 16.h,
  );
  static final aroundPadding = EdgeInsets.symmetric(
    horizontal: 16.w,
    vertical: 16.h,
  );

  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;

  static const double borderRadius = 12.0;
  static const double fontSizeTitle = 22.0;
  static const double fontSizeSubtitle = 18.0;
  static const double fontSizeBody = 14.0;

  static const double buttonHeight = 48.0;
  static const double buttonWidth = 200.0;
}
