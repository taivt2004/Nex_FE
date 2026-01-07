import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nexpaylab/share/ui/widget/nice_buttons.dart';

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
    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Theme(
        data: Theme.of(context).copyWith(
          primaryColor: const Color(0xFF7E11D8),
          primaryColorDark: const Color(0xFF7E11D8),
        ),
        child: NiceButtons(
          height: 52.h,
          borderRadius: 28.r,
          borderThickness: 0,
          stretch: true,
          progress: false,
          disabled: !enabled,
          onTap: (finish) {
            if (enabled) {
              onPressed();
            }
            finish();
          },
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
