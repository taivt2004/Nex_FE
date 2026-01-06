import 'package:flutter/material.dart';
import 'package:nexpaylab/share/theme/app_style.dart';

class PassphraseSection extends StatelessWidget {
  const PassphraseSection({
    required this.isSecure,
    required this.onChanged,
    super.key,
  });
  final bool isSecure;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => onChanged(!isSecure),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSecure ? const Color(0xFF7B61FF) : Colors.white30,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  color: isSecure
                      ? const Color(0xFF7B61FF)
                      : Colors.transparent,
                ),
                child: isSecure
                    ? const Icon(Icons.check, size: 14, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Text(
                'Secure your wallet with a Passphrase',
                style: PoppinsTextStyles.primary14Regular.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.info_outline, size: 18, color: Colors.white38),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Passphrase is used to secure your Wallet's Secret phrase, creating multi-layered security to prevent unauthorized access or leakage.",
                style: PoppinsTextStyles.primary12Regular,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
