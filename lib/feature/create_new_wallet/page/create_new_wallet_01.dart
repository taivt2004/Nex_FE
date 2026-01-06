import 'package:flutter/material.dart';
import 'package:nexpaylab/feature/create_new_wallet/widget/create_wallet_button.dart';
import 'package:nexpaylab/feature/create_new_wallet/widget/passphrase_section.dart';
import 'package:nexpaylab/feature/create_new_wallet/widget/wallet_name_input.dart';
import 'package:nexpaylab/share/theme/app_style.dart';

class CreateNewWallet01Page extends StatefulWidget {
  const CreateNewWallet01Page({super.key});

  @override
  State<CreateNewWallet01Page> createState() => _CreateNewWallet01PageState();
}

class _CreateNewWallet01PageState extends State<CreateNewWallet01Page> {
  bool _isSecureWithPassphrase = false;
  final TextEditingController _walletNameController = TextEditingController(
    text: 'Wallet 1',
  );
  String? _walletNameError;

  String? _validateWalletName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Wallet name cannot be empty';
    }
    if (trimmed.length > 24) {
      return 'Max 24 characters';
    }
    final valid = RegExp(r'^[A-Za-z0-9 ]+$');
    if (!valid.hasMatch(trimmed)) {
      return 'Only letters, numbers and spaces are allowed';
    }
    return null;
  }

  @override
  void dispose() {
    _walletNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121314),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121314),

        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create new wallet',
          style: PoppinsTextStyles.primary18Regular.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WalletNameInput(
              controller: _walletNameController,
              errorText: _walletNameError,
              onChanged: (value) {
                setState(() {
                  _walletNameError = _validateWalletName(value);
                });
              },
            ),
            const SizedBox(height: 24),
            PassphraseSection(
              isSecure: _isSecureWithPassphrase,
              onChanged: (value) {
                setState(() {
                  _isSecureWithPassphrase = value;
                });
              },
            ),
            const Spacer(),
            CreateWalletButton(
              onPressed: () {
                setState(() {
                  _walletNameError = _validateWalletName(
                    _walletNameController.text,
                  );
                });
                if (_walletNameError != null) {
                  return;
                }
                // TODO: Proceed create wallet with valid name
              },
            ),
          ],
        ),
      ),
    );
  }
}
