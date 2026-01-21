import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';
import 'package:nexpaylab/shared/ui/extensions/image.dart';

class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    this.walletTitle = 'Main Wallet',
    this.onMenuTap,
    this.onWalletTap,
    this.onSearchTap,
    this.onNotificationTap,
    super.key,
  });

  final String walletTitle;
  final VoidCallback? onMenuTap;
  final VoidCallback? onWalletTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _TopBarIconButton(
          
          icon: AppAssets.homeTopbar.gridIcon.load(
            color: Theme.of(context).primaryColor,
            width: 22.sp,
            height: 22.sp,
          ),
          onTap: onMenuTap,
        ),
        SizedBox(width: 8.w),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onWalletTap,
          child: Row(
            children: [
              Text(walletTitle, style: PoppinsTextStyles.display16Medium),
              SizedBox(width: 4.w),
              Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                size: 20.sp,
              ),
            ],
          ),
        ),
        Row(
          children: [
            _TopBarIconButton(
              icon: AppAssets.homeTopbar.searchIcon.load(
                color: Theme.of(context).primaryColor,
                width: 22.sp,
                height: 22.sp,
              ),
              onTap: onSearchTap,
            ),
            SizedBox(width: 8.w),
            _TopBarIconButton(
              icon: AppAssets.homeTopbar.notifiIcon.load(
                color: Theme.of(context).primaryColor,
                width: 22.sp,
                height: 22.sp,
              ),
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
      child: SizedBox(
        width: 32.w,
        height: 32.w,
        child: Center(child: icon),
      ),
    );
  }
}
