import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/gen/assets.gen.dart';
import 'package:nexpaylab/share/theme/app_style.dart';
import 'package:nexpaylab/share/ui/extensions/image.dart';

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
          style: PoppinsTextStyles.primary16Semibold,
        ),
        Row(
          children: [
            _SquareIconButton(
              icon: Assets.icons.home.cryptActives.settingCryptActive.load(
                color: Colors.white,
                width: 18.sp,
                height: 18.sp,
              ),
              onTap: onFilterTap,
            ),
            SizedBox(width: 8.w),
            _SquareIconButton(
              icon: Assets.icons.home.cryptActives.historyIcon.load(
                color: Colors.white,
                width: 18.sp,
                height: 18.sp,
              ),
              onTap: onHistoryTap,
            ),
          ],
        ),
      ],
    );
  }
}

class _SquareIconButton extends StatelessWidget {
  const _SquareIconButton({required this.icon, this.onTap});

  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 32.w,
        height: 32.w,
        alignment: Alignment.center,
        child: icon,
      ),
    );
  }
}
