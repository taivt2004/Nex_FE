import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/features/on_boarding/already_have_wallet/cubit/already_have_wallet_cubit.dart';
import 'package:nexpaylab/features/on_boarding/already_have_wallet/widget/secret_phrase_input.dart';
import 'package:nexpaylab/features/on_boarding/widget/common/create_wallet_button.dart';
import 'package:nexpaylab/features/on_boarding/widget/common/passphrase_section.dart';
import 'package:nexpaylab/features/on_boarding/widget/common/wallet_name_input.dart';
import 'package:nexpaylab/features/on_boarding/widget/onboarding_scaffold.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';

class AlreadyHaveWallet01Page extends StatefulWidget {
  const AlreadyHaveWallet01Page({super.key});

  @override
  State<AlreadyHaveWallet01Page> createState() =>
      _AlreadyHaveWallet01PageState();
}

class _AlreadyHaveWallet01PageState extends State<AlreadyHaveWallet01Page> {
  late final TextEditingController _walletNameController;
  late final TextEditingController _secretPhraseController;

  AlreadyHaveWalletError? _validateWalletName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return AlreadyHaveWalletError.walletNameRequired;
    return null;
  }

  String? _getWalletNameErrorText(
    AlreadyHaveWalletError? error,
    AppLocalizations l10n,
  ) {
    switch (error) {
      case AlreadyHaveWalletError.walletNameRequired:
        return l10n.errorWalletNameRequired;
      case null:
        return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _walletNameController = TextEditingController();
    _secretPhraseController = TextEditingController();
  }

  @override
  void dispose() {
    _walletNameController.dispose();
    _secretPhraseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => AlreadyHaveWalletCubit(),
      child: BlocBuilder<AlreadyHaveWalletCubit, AlreadyHaveWalletState>(
        builder: (context, state) {
          return OnboardingScaffold(
            title: l10n.addExistingWallet,
            backgroundColor: const Color(0xFF121314),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WalletNameInput(
                  controller: _walletNameController,
                  errorText:
                      _getWalletNameErrorText(state.walletNameError, l10n),
                  onChanged: (value) {
                    context.read<AlreadyHaveWalletCubit>().setWalletName(
                      value,
                      error: _validateWalletName(value),
                    );
                  },
                ),
                SizedBox(height: 20.h),
                SecretPhraseInput(
                  controller: _secretPhraseController,
                  onChanged: (value) {
                    context.read<AlreadyHaveWalletCubit>().setSecretPhrase(value);
                  },
                ),
                SizedBox(height: 20.h),
                PassphraseSection(
                  isSecure: state.isSecure,
                  onChanged: (value) {
                    context.read<AlreadyHaveWalletCubit>().toggleSecure(isSecure: value);
                  },
                  onPassphraseChanged: (value) {
                    context.read<AlreadyHaveWalletCubit>().setPassphrase(value);
                  },
                  onConfirmPassphraseChanged: (_) {},
                  errorText: null,
                  title: l10n.enterPassphrase,
                  enableConfirm: false,
                  showInfo: false,
                ),
                SizedBox(height: 20.h),
              ],
            ),
            bottomButton: BlocBuilder<AlreadyHaveWalletCubit, AlreadyHaveWalletState>(
              buildWhen: (previous, current) =>
                  previous.isSecretValid != current.isSecretValid,
              builder: (context, state) {
                return CreateWalletButton(
                  text: l10n.restoreWallet,
                  enabled: state.isSecretValid,
                  onPressed: () {
                    context.go(AppRouter.home);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
