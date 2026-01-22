import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';
import 'package:nexpaylab/app/di/dependency_injection.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/features/on_boarding/create_new_wallet/cubit/create_wallet_cubit.dart';
import 'package:nexpaylab/features/on_boarding/widget/common/create_wallet_button.dart';
import 'package:nexpaylab/features/on_boarding/widget/common/passphrase_section.dart';
import 'package:nexpaylab/features/on_boarding/widget/common/wallet_name_input.dart';
import 'package:nexpaylab/features/on_boarding/widget/onboarding_scaffold.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

class CreateNewWallet01Page extends StatefulWidget {
  const CreateNewWallet01Page({super.key});

  @override
  State<CreateNewWallet01Page> createState() => _CreateNewWallet01PageState();
}

class _CreateNewWallet01PageState extends State<CreateNewWallet01Page> {
  late final TextEditingController _walletNameController;

  @override
  void initState() {
    super.initState();
    _walletNameController = TextEditingController(text: 'Wallet 1');
  }

  CreateWalletError? _validateWalletName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return CreateWalletError.walletNameRequired;
    if (trimmed.length > 24) return CreateWalletError.walletNameLength;
    final valid = RegExp(r'^[A-Za-z0-9 ]+$');
    if (!valid.hasMatch(trimmed)) return CreateWalletError.walletNameInvalid;
    return null;
  }
  
  String? _getWalletNameErrorText(
    CreateWalletError? error,
    AppLocalizations l10n,
  ) {
    switch (error) {
      case CreateWalletError.walletNameRequired:
        return l10n.errorWalletNameRequired;
      case CreateWalletError.walletNameLength:
        return l10n.errorWalletNameLength;
      case CreateWalletError.walletNameInvalid:
        return l10n.errorWalletNameInvalid;
      case null:
      case CreateWalletError.passphraseMismatch: // Should not happen for wallet name
        return null;
    }
  }

  String? _getPassphraseErrorText(
    CreateWalletError? error,
    AppLocalizations l10n,
  ) {
    if (error == CreateWalletError.passphraseMismatch) {
      return l10n.errorPassphraseMismatch;
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
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => CreateWalletCubit()
        ..setWalletName(
          _walletNameController.text,
          error: _validateWalletName(_walletNameController.text),
        ),
      child: BlocBuilder<CreateWalletCubit, CreateWalletState>(
        builder: (context, state) {
          return OnboardingScaffold(
            title: l10n.createNewWallet,
            backgroundColor: OlaColors.appbackground,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WalletNameInput(
                  controller: _walletNameController,
                  errorText:
                      _getWalletNameErrorText(state.walletNameError, l10n),
                  onChanged: (value) {
                    context.read<CreateWalletCubit>().setWalletName(
                          value,
                          error: _validateWalletName(value),
                        );
                  },
                ),
                SizedBox(height: 24.h),
                PassphraseSection(
                  isSecure: state.isSecure,
                  errorText: _getPassphraseErrorText(state.passphraseError, l10n),
                  onChanged: (value) {
                    context.read<CreateWalletCubit>().toggleSecure(
                          isSecure: value,
                        );
                  },
                  onPassphraseChanged: (value) {
                    context.read<CreateWalletCubit>().setPassphrase(
                          value,
                        );
                  },
                  onConfirmPassphraseChanged: (value) {
                    context.read<CreateWalletCubit>().setConfirmPassphrase(value);
                  },
                ),
                SizedBox(height: 24.h),
              ],
            ),
            bottomButton: CreateWalletButton(
              text: l10n.createAction,
              enabled: state.isFormValid,
              onPressed: () async {
                final cubit = context.read<CreateWalletCubit>();
                final error = _validateWalletName(_walletNameController.text);
                cubit.setWalletName(_walletNameController.text, error: error);
                if (cubit.state.walletNameError != null) {
                  return;
                }

                await cubit.savePassphraseToDB(
                  getIt<AppConfigLocalStore>(),
                );

                if (context.mounted) {
                  context.go(AppRouter.home);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
