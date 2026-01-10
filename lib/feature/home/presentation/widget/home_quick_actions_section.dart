import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeQuickActionItemData {
  const HomeQuickActionItemData({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onTap;
}

class HomeQuickActionsSection extends StatelessWidget {
  const HomeQuickActionsSection({required this.actions, super.key});

  final List<HomeQuickActionItemData> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick actions',
          style: TextStyle(color: Colors.grey, fontSize: 13.sp),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: actions
              .map(
                (action) => _HomeActionButton(
                  icon: action.icon,
                  label: action.label,
                  onTap: action.onTap,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _HomeActionButton extends StatelessWidget {
  const _HomeActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  final Widget icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              color: const Color(0xFF262A34),
              borderRadius: BorderRadius.circular(16.r),
            ),
            alignment: Alignment.center,
            child: icon,
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}
