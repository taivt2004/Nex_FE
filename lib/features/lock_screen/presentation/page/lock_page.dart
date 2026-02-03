import 'package:flutter/material.dart' hide LockState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/di/dependency_injection.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/features/lock_screen/presentation/bloc/lock_bloc.dart';
import 'package:nexpaylab/features/lock_screen/presentation/widget/lock_pin_input.dart';
import 'package:nexpaylab/features/lock_screen/presentation/widget/reset_wallet_dialog.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

class LockPage extends StatelessWidget {
  const LockPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<LockBloc>()..add(LockStarted()),
      child: const _LockView(),
    );
  }
}

class _LockView extends StatefulWidget {
  const _LockView();

  @override
  State<_LockView> createState() => _LockViewState();
}

class _LockViewState extends State<_LockView> {
  final TextEditingController _passphraseController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _passphraseController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _resetWallet(BuildContext context) async {
    final confirmed = await ResetWalletDialog.show(context);

    if ((confirmed ?? false) && context.mounted) {
      context.read<LockBloc>().add(ResetWalletConfirmed());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocConsumer<LockBloc, LockState>(
      listener: (context, state) {
        if (state.status == LockStatus.authenticated) {
          context.go(AppRouter.home);
        } else if (state.status == LockStatus.unauthenticated ||
            state.status == LockStatus.resetDone) {
          context.go(AppRouter.onboarding);
        } else if (state.error == LockError.incorrectPassphrase) {
          _passphraseController.clear();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 64.sp,
                    color: OlaColors.primarycolor,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    l10n.lockScreenTitle,
                    style: PoppinsTextStyles.primary18Regular.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    l10n.lockScreenSubtitle,
                    style: PoppinsTextStyles.primary14Regular.copyWith(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  SizedBox(height: 48.h),
                  LockPinInput(
                    controller: _passphraseController,
                    focusNode: _focusNode,
                    onChanged: (value) =>
                        context.read<LockBloc>().add(PassphraseChanged(value)),
                    hasError: state.error == LockError.incorrectPassphrase,
                  ),
                  if (state.error == LockError.incorrectPassphrase) ...[
                    SizedBox(height: 16.h),
                    Text(
                      l10n.incorrectPassphrase,
                      style: PoppinsTextStyles.primary14Regular.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                  const Spacer(),
                  TextButton(
                    onPressed: () => _resetWallet(context),
                    child: Text(
                      l10n.forgotPassphrase,
                      style: PoppinsTextStyles.primary14Regular.copyWith(
                        color: OlaColors.primarycolor,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
