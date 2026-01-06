import 'package:flutter/material.dart';
import 'package:nexpaylab/share/ui/widget/nice_buttons.dart';

class CreateWalletButton extends StatelessWidget {
  const CreateWalletButton({required this.onPressed, super.key});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: const Color(0xFF7E11D8),
        primaryColorDark: const Color(0xFF7E11D8),
      ),
      child: NiceButtons(
        height: 52,
        borderRadius: 28,
        borderThickness: 0,
        stretch: true,
        progress: false,
        disabled: false,
        onTap: (finish) {
          onPressed();
          finish();
        },
        child: const Text(
          'Create',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
