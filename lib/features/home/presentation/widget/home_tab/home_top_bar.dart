import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';
import 'package:nexpaylab/shared/ui/extensions/image.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    this.appTitle = 'NexPay',
    this.onProfileTap,
    this.onNotificationTap,
    this.onActionTap,
    super.key,
  });

  final String appTitle;
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: AppAssets.images.icApp.load(
                width: 34.w,
                height: 34.w,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              appTitle,
              style: PoppinsTextStyles.primary18Bold.copyWith(
                color: Colors.white,
              ),
            ),
          ],
        ),
        Row(
          children: [
            _TopBarIconButton(
              icon: Icon(
                Icons.person_outline_rounded,
                color: OlaColors.primarycolor,
                size: 22.sp,
              ),
              onTap: onProfileTap,
            ),
            SizedBox(width: 10.w),
            _TopBarIconButton(
              icon: AppAssets.homeTopbar.notifiIcon.load(
                color: Colors.white,
                width: 21.sp,
                height: 21.sp,
              ),
              onTap: onNotificationTap,
            ),
            SizedBox(width: 10.w),
            _TopBarIconButton(
              icon: Icon(
                Icons.add_circle_outline_rounded,
                color: Colors.white,
                size: 22.sp,
              ),
              onTap: onActionTap,
            ),
          ],
        ),
      ],
    );
  }
}

class _TopBarIconButton extends StatelessWidget {
  const _TopBarIconButton({required this.icon, this.onTap});

  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        width: 34.w,
        height: 34.w,
        decoration: BoxDecoration(
          color: const Color(0xFF12151B),
          borderRadius: BorderRadius.circular(17.r),
        ),
        alignment: Alignment.center,
        child: icon,
      ),
    );
  }
}
