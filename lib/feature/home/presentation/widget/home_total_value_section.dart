import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/share/theme/app_style.dart';

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
    final statusColor = isSynced ? const Color(0xFF00C566) : Colors.red;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              totalLabel,
              style: PoppinsTextStyles.display16Regular.copyWith(
                color: Colors.grey,
              ),
            ),
            Row(
              children: [
                Icon(Icons.circle, size: 6.r, color: statusColor),
                SizedBox(width: 4.w),
                Text(
                  isSynced ? 'Sync' : 'Unsync',
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onSyncTap,
                  child: Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    alignment: Alignment.center,
                    child: Icon(Icons.refresh, color: Colors.grey, size: 16.sp),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Text(
              balance,
              style: PoppinsTextStyles.display36Medium.copyWith(
                color: Colors.white,
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
                  color: Colors.grey,
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
                color: Colors.grey,
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
