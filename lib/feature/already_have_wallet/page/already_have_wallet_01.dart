import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/share/theme/app_style.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/feature/create_new_wallet/widget/wallet_name_input.dart';
import 'package:nexpaylab/feature/create_new_wallet/widget/passphrase_section.dart';
import 'package:nexpaylab/feature/create_new_wallet/widget/create_wallet_button.dart';

class AlreadyHaveWallet01Page extends StatefulWidget {
  const AlreadyHaveWallet01Page({super.key});

  @override
  State<AlreadyHaveWallet01Page> createState() =>
      _AlreadyHaveWallet01PageState();
}

class _AlreadyHaveWallet01PageState extends State<AlreadyHaveWallet01Page> {
  late final TextEditingController _walletNameController;
  late final TextEditingController _secretPhraseController;
  bool _isSecure = false;
  String _passphrase = '';

  @override
  void initState() {
    super.initState();
    _walletNameController = TextEditingController(text: 'Wallet 1');
    _secretPhraseController = TextEditingController();
  }

  @override
  void dispose() {
    _walletNameController.dispose();
    _secretPhraseController.dispose();
    super.dispose();
  }

  bool get _isSecretValid {
    final text = _secretPhraseController.text.trim();
    if (text.isEmpty) return false;
    final words = text.split(RegExp(r'\s+'));
    return words.length == 12;
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
          'Add existing wallet',
          style: PoppinsTextStyles.primary18Regular.copyWith(
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              WalletNameInput(
                controller: _walletNameController,
                errorText: null,
                onChanged: (_) {},
              ),
              SizedBox(height: 20.h),
              Text(
                'Secret phrase',
                style: TextStyle(color: Colors.white70, fontSize: 14.sp),
              ),
              SizedBox(height: 10.h),
              Stack(
                children: [
                  TextField(
                    controller: _secretPhraseController,
                    maxLines: 4,
                    minLines: 3,
                    style: const TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF2A2A3A),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 16.h,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 0,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color(0xFF7B61FF),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 12.w,
                    bottom: 8.h,
                    child: GestureDetector(
                      onTap: () async {
                        final data = await Clipboard.getData('text/plain');
                        final text = data?.text ?? '';
                        _secretPhraseController.text = text;
                        setState(() {});
                      },
                      child: Text(
                        'Paste',
                        style: PoppinsTextStyles.primary14Regular.copyWith(
                          color: const Color(0xFF7E11D8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                'Typically 12 words separated by single spaces',
                style: PoppinsTextStyles.primary12Regular.copyWith(
                  color: Colors.white54,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 20.h),
              PassphraseSection(
                isSecure: _isSecure,
                onChanged: (value) => setState(() => _isSecure = value),
                onPassphraseChanged: (value) => _passphrase = value,
                onConfirmPassphraseChanged: (_) {},
                errorText: null,
                title: 'Enter Passphrase (if your wallet has)',
                enableConfirm: false,
                showInfo: false,
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.fromLTRB(
          20.w,
          8.h,
          20.w,
          16.h + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: CreateWalletButton(
          text: 'Restore wallet',
          enabled: _isSecretValid,
          onPressed: () {
            context.go(AppRouter.home);
          },
        ),
      ),
    );
  }
}
