import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/share/theme/app_style.dart';

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
        _TopBarIconButton(icon: Icons.grid_view_rounded, onTap: onMenuTap),
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onWalletTap,
          child: Row(
            children: [
              Text(walletTitle, style: PoppinsTextStyles.display16Medium),
              SizedBox(width: 4.w),
              Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 20.sp),
            ],
          ),
        ),
        Row(
          children: [
            _TopBarIconButton(icon: Icons.search, onTap: onSearchTap),
            SizedBox(width: 8.w),
            _TopBarIconButton(
              icon: Icons.notifications_outlined,
              onTap: onNotificationTap,
            ),
          ],
        ),
      ],
    );
  }
}

class _TopBarIconButton extends StatelessWidget {
  const _TopBarIconButton({required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 32.w,
        height: 32.w,
        child: Center(
          child: Icon(icon, color: Colors.white, size: 22.sp),
        ),
      ),
    );
  }
}
