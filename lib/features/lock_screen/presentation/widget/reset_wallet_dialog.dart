import 'package:flutter/material.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';

class ResetWalletDialog extends StatelessWidget {
  const ResetWalletDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => const ResetWalletDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.resetWalletTitle),
      content: Text(
        l10n.resetWalletMessage,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: Text(l10n.reset),
        ),
      ],
    );
  }
}
