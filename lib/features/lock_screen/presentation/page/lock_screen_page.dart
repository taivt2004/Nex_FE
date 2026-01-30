import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/di/dependency_injection.dart';
import 'package:nexpaylab/app/router/app_router.dart';
import 'package:nexpaylab/features/lock_screen/presentation/bloc/lock_screen_bloc.dart';
import 'package:nexpaylab/features/lock_screen/presentation/widget/lock_pin_input.dart';
import 'package:nexpaylab/l10n/arb/app_localizations.dart';
import 'package:nexpaylab/shared/theme/app_style.dart';

class LockScreenPage extends StatefulWidget {
  const LockScreenPage({super.key});

  @override
  State<LockScreenPage> createState() => _LockScreenPageState();
}

class _LockScreenPageState extends State<LockScreenPage> {
  final TextEditingController _passphraseController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _passphraseController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onPassphraseChanged(BuildContext context, String value) {
    context.read<LockBloc>().add(PassphraseChanged(value));
    if (value.length == 6) {
      context.read<LockBloc>().add(PassphraseSubmitted(value));
    }
  }

  Future<void> _resetWallet(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
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
      ),
    );

    if ((confirmed ?? false) && context.mounted) {
      context.read<LockBloc>().add(ResetWalletConfirmed());
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => getIt<LockBloc>()..add(LockStarted()),
      child: BlocConsumer<LockBloc, LockScreenState>(
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
            backgroundColor: OlaColors.appbackground,
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
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      l10n.lockScreenSubtitle,
                      style: PoppinsTextStyles.primary14Regular.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                    SizedBox(height: 48.h),
                    LockPinInput(
                      controller: _passphraseController,
                      focusNode: _focusNode,
                      onChanged: (value) =>
                          _onPassphraseChanged(context, value),
                      hasError: state.error == LockError.incorrectPassphrase,
                    ),
                    if (state.error == LockError.incorrectPassphrase) ...[
                      SizedBox(height: 16.h),
                      Text(
                        l10n.incorrectPassphrase,
                        style: PoppinsTextStyles.primary14Regular.copyWith(
                          color: const Color(0xFFFF3B30),
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
      ),
    );
  }
}
