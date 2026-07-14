import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/gen/assets.gen.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';
import 'package:nexpaylab/shared/ui/extensions/image.dart';

class HomeCryptoActivesHeader extends StatelessWidget {
  const HomeCryptoActivesHeader({
    this.onFilterTap,
    this.onSortTap,
    super.key,
  });

  final VoidCallback? onFilterTap;
  final VoidCallback? onSortTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const _FilterChip(
                      label: 'Tất cả',
                      isSelected: true,
                      textColor: Color(0xFF1DB954),
                    ),
                    SizedBox(width: 10.w),
                    const _FilterChip(label: '🔥 Xu thế'),
                    SizedBox(width: 10.w),
                    const _FilterChip(label: '🚀 Tăng mạnh'),
                  ],
                ),
              ),
            ),
            SizedBox(width: 10.w),
            _IconChip(
              icon: Icons.swap_vert_rounded,
              onTap: onSortTap,
            ),
            SizedBox(width: 10.w),
            _IconChip(
              iconWidget: Assets.icons.home.cryptActives.settingCryptActive.load(
                color: Colors.white,
                width: 18.sp,
                height: 18.sp,
              ),
              onTap: onFilterTap,
            ),
          ],
        ),
        SizedBox(height: 18.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Row(
            children: [
              SizedBox(
                width: 22.w,
                child: Text(
                  '#',
                  style: PoppinsTextStyles.primary12Regular.copyWith(
                    color: OlaColors.gray400,
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  'Đồng tiền',
                  style: PoppinsTextStyles.primary12Regular.copyWith(
                    color: OlaColors.gray400,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  'Giá',
                  textAlign: TextAlign.right,
                  style: PoppinsTextStyles.primary12Regular.copyWith(
                    color: OlaColors.gray400,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  '24 GIỜ',
                  textAlign: TextAlign.right,
                  style: PoppinsTextStyles.primary12Regular.copyWith(
                    color: OlaColors.gray400,
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  'Vốn hoá',
                  textAlign: TextAlign.right,
                  style: PoppinsTextStyles.primary12Regular.copyWith(
                    color: OlaColors.gray400,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    this.isSelected = false,
    this.textColor,
  });

  final String label;
  final bool isSelected;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF10311E) : const Color(0xFF15181E),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Text(
        label,
        style: PoppinsTextStyles.primary14Semibold.copyWith(
          color: textColor ?? Colors.white,
        ),
      ),
    );
  }
}

class _IconChip extends StatelessWidget {
  const _IconChip({
    this.icon,
    this.iconWidget,
    this.onTap,
  }) : assert(
          icon != null || iconWidget != null,
          'icon hoặc iconWidget phải khác null',
        );

  final IconData? icon;
  final Widget? iconWidget;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 44.w,
        height: 44.w,
        decoration: BoxDecoration(
          color: const Color(0xFF15181E),
          borderRadius: BorderRadius.circular(22.r),
        ),
        alignment: Alignment.center,
        child: iconWidget ??
            Icon(
              icon,
              color: Colors.white,
              size: 20.sp,
            ),
      ),
    );
  }
}
