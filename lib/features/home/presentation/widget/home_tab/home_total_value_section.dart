import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

class HomeTotalValueSection extends StatelessWidget {
  const HomeTotalValueSection({
    required this.isSynced,
    this.onSyncTap,
    this.totalLabel = 'Total value',
    this.balance = '1.500.000',
    this.currency = 'USD',
    this.periodLabel = 'Today',
    this.changeText = r'350$ (2.70%)',
    this.changeColor = const Color(0xFF00C566),
    super.key,
  });

  final bool isSynced;
  final VoidCallback? onSyncTap;
  final String totalLabel;
  final String balance;
  final String currency;
  final String periodLabel;
  final String changeText;
  final Color changeColor;

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              totalLabel,
              style: PoppinsTextStyles.display16Regular.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              balance,
              style: PoppinsTextStyles.display36Medium.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(width: 8.w),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  currency,
                  style: PoppinsTextStyles.display16Medium.copyWith(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16.sp,
                ),
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              periodLabel,
              style: PoppinsTextStyles.primary12Regular.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            SizedBox(width: 6.w),
            Icon(Icons.trending_up, color: changeColor, size: 14.sp),
            SizedBox(width: 2.w),
            Text(
              changeText,
              style: PoppinsTextStyles.primary12Regular.copyWith(
                color: changeColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
