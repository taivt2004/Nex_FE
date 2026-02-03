import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';
import 'package:nexpaylab/app/di/dependency_injection.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/features/on_boarding/create_new_wallet/bloc/create_wallet_bloc.dart';
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
      case CreateWalletError.passphraseMismatch:
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
      create: (_) => CreateWalletBloc(getIt<AppConfigLocalStore>())
        ..add(WalletNameChanged(_walletNameController.text)),
      child: BlocConsumer<CreateWalletBloc, CreateWalletState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          if (state.status == CreateWalletStatus.success) {
            context.go(AppRouter.home);
          }
        },
        builder: (context, state) {
          return OnboardingScaffold(
            title: l10n.createNewWallet,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                WalletNameInput(
                  controller: _walletNameController,
                  errorText:
                      _getWalletNameErrorText(state.walletNameError, l10n),
                  onChanged: (value) {
                    context.read<CreateWalletBloc>().add(
                          WalletNameChanged(value),
                        );
                  },
                ),
                SizedBox(height: 24.h),
                PassphraseSection(
                  isSecure: state.isSecure,
                  errorText: _getPassphraseErrorText(state.passphraseError, l10n),
                  onChanged: (value) {
                    context.read<CreateWalletBloc>().add(
                          SecureToggled(isSecure: value),
                        );
                  },
                  onPassphraseChanged: (value) {
                    context.read<CreateWalletBloc>().add(
                          PassphraseChanged(value),
                        );
                  },  
                  onConfirmPassphraseChanged: (value) {
                    context.read<CreateWalletBloc>().add(
                          ConfirmPassphraseChanged(value),
                        );
                  },
                ),
                SizedBox(height: 24.h),
              ],
            ),
            bottomButton: CreateWalletButton(
              text: l10n.createAction,
              enabled: state.isFormValid &&
                  state.status != CreateWalletStatus.submitting,
              onPressed: () {
                context.read<CreateWalletBloc>().add(
                      const CreateWalletSubmitted(),
                    );
              },
            ),
          );
        },
      ),
    );
  }
}
