import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/feature/on_boarding/already_have_wallet/cubit/already_have_wallet_cubit.dart';
import 'package:nexpaylab/feature/on_boarding/already_have_wallet/widget/secret_phrase_input.dart';
import 'package:nexpaylab/feature/on_boarding/create_new_wallet/widget/create_wallet_button.dart';
import 'package:nexpaylab/feature/on_boarding/create_new_wallet/widget/passphrase_section.dart';
import 'package:nexpaylab/feature/on_boarding/create_new_wallet/widget/wallet_name_input.dart';
import 'package:nexpaylab/share/theme/app_style.dart';

class AlreadyHaveWallet01Page extends StatefulWidget {
  const AlreadyHaveWallet01Page({super.key});

  @override
  State<AlreadyHaveWallet01Page> createState() =>
      _AlreadyHaveWallet01PageState();
}

class _AlreadyHaveWallet01PageState extends State<AlreadyHaveWallet01Page> {
  late final TextEditingController _walletNameController;
  late final TextEditingController _secretPhraseController;
  late final AlreadyHaveWalletCubit _cubit;

  @override
  void initState() {
    super.initState();
    _walletNameController = TextEditingController(text: 'Wallet 1');
    _secretPhraseController = TextEditingController();
    _cubit = AlreadyHaveWalletCubit();
  }

  @override
  void dispose() {
    _walletNameController.dispose();
    _secretPhraseController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: const Color(0xFF121314),
        appBar: AppBar(
          backgroundColor: const Color(0xFF121314),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Add existing wallet',
            style: PoppinsTextStyles.primary18Regular.copyWith(
              color: Colors.white,
            ),
          ),
        ),
        resizeToAvoidBottomInset: true, // CHANGED: true để Flutter tự handle
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.r),
                  child:
                      BlocBuilder<
                        AlreadyHaveWalletCubit,
                        AlreadyHaveWalletState
                      >(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WalletNameInput(
                                controller: _walletNameController,
                                errorText: state.walletNameError,
                                onChanged: (value) {
                                  _cubit
                                    ..setWalletName(value)
                                    ..validateWalletName();
                                },
                              ),
                              SizedBox(height: 20.h),
                              SecretPhraseInput(
                                controller: _secretPhraseController,
                                onChanged: (value) {
                                  _cubit.setSecretPhrase(value);
                                },
                              ),
                              SizedBox(height: 20.h),
                              PassphraseSection(
                                isSecure: state.isSecure,
                                onChanged: (value) {
                                  _cubit.toggleSecure(isSecure: value);
                                },
                                onPassphraseChanged: (value) {
                                  _cubit.setPassphrase(value);
                                },
                                onConfirmPassphraseChanged: (_) {},
                                errorText: null,
                                title: 'Enter Passphrase (if your wallet has)',
                                enableConfirm: false,
                                showInfo: false,
                              ),
                              SizedBox(height: 20.h),
                            ],
                          );
                        },
                      ),
                ),
              ),
              // Button fixed ở bottom
              BlocBuilder<AlreadyHaveWalletCubit, AlreadyHaveWalletState>(
                buildWhen: (previous, current) =>
                    previous.isSecretValid != current.isSecretValid,
                builder: (context, state) {
                  return Container(
                    padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFF121314),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: CreateWalletButton(
                      text: 'Restore wallet',
                      enabled: state.isSecretValid,
                      onPressed: () {
                        context.go(AppRouter.home);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
