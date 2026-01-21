import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';
import 'package:nexpaylab/app/di/injector.dart';
import 'package:nexpaylab/app/router/app_router.dart';
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
  String? _errorText;
  String? _storedPassphrase;

  @override
  void initState() {
    super.initState();
    _loadPassphrase();
  }

  Future<void> _loadPassphrase() async {
    final configStore = getIt<AppConfigLocalStore>();
    final result = await configStore
        .getConfigByKey('local_passphrase')
        .getSingleOrNull();
    if (result != null) {
      _storedPassphrase = result.value;
    } else {
      // Should not happen if we routed correctly, but safe fallback
      if (mounted) context.go(AppRouter.onboarding);
    }
  }

  @override
  void dispose() {
    _passphraseController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onPassphraseChanged(String value) {
    if (_errorText != null) {
      setState(() => _errorText = null);
    }

    if (value.length == 6) {
      _validatePassphrase(value);
    }
  }

  void _validatePassphrase(String value) {
    if (value == _storedPassphrase) {
      context.go(AppRouter.home);
    } else {
      setState(() {
        _errorText = AppLocalizations.of(context).incorrectPassphrase;
        _passphraseController.clear();
      });
    }
  }

  Future<void> _resetWallet() async {
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

    if (confirmed ?? false) {
      await getIt<AppConfigLocalStore>().clearConfigAll();
      if (mounted) context.go(AppRouter.onboarding);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
                onChanged: _onPassphraseChanged,
                hasError: _errorText != null,
              ),
              if (_errorText != null) ...[
                SizedBox(height: 16.h),
                Text(
                  _errorText!,
                  style: PoppinsTextStyles.primary14Regular.copyWith(
                    color: const Color(0xFFFF3B30),
                  ),
                ),
              ],
              const Spacer(),
              TextButton(
                onPressed: _resetWallet,
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
  }
}
