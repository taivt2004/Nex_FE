import 'package:flutter/material.dart';

class WalletNameInput extends StatelessWidget {
  const WalletNameInput({
    required this.controller,
    this.errorText,
    this.onChanged,
    super.key,
  });
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Wallet name',
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2A2A3A),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? const Color(0xFFFF3B30) : Colors.transparent,
                width: hasError ? 1.5 : 0,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError
                    ? const Color(0xFFFF3B30)
                    : const Color(0xFF7B61FF),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFFF3B30),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xFFFF3B30),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            errorText: errorText,
            errorStyle: const TextStyle(color: Color(0xFFFF3B30), fontSize: 12),
            suffixIcon: hasError
                ? IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white70,
                      size: 20,
                    ),
                    onPressed: () {
                      controller.clear();
                      if (onChanged != null) {
                        onChanged!('');
                      }
                    },
                    enableFeedback: false,
                    splashRadius: 20,
                  )
                : IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.white54,
                      size: 20,
                    ),
                    onPressed: () {},
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    enableFeedback: false,
                    splashRadius: 20,
                  ),
          ),
        ),
      ],
    );
  }
}
