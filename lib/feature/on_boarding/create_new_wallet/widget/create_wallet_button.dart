import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/share/theme/app_style.dart';

class CreateWalletButton extends StatelessWidget {
  const CreateWalletButton({
    required this.onPressed,
    this.enabled = true,
    this.text = 'Create',
    super.key,
  });
  final VoidCallback onPressed;
  final bool enabled;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: OlaColors.primarycolor,
          disabledBackgroundColor: OlaColors.primarycolor.withOpacity(0.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          elevation: 0,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
