import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeCryptoActivesHeader extends StatelessWidget {
  const HomeCryptoActivesHeader({
    this.title = 'Crypto actives',
    this.onFilterTap,
    this.onHistoryTap,
    super.key,
  });

  final String title;
  final VoidCallback? onFilterTap;
  final VoidCallback? onHistoryTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          children: [
            _SquareIconButton(icon: Icons.tune_rounded, onTap: onFilterTap),
            SizedBox(width: 8.w),
            _SquareIconButton(icon: Icons.history_rounded, onTap: onHistoryTap),
          ],
        ),
      ],
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        decoration: BoxDecoration(
          color: const Color(0xFF262A34),
          borderRadius: BorderRadius.circular(8.r),
        ),
        alignment: Alignment.center,
        child: Icon(icon, color: Colors.white, size: 18.sp),
      ),
    );
  }
}
