import 'package:nexpaylab/l10n/arb/app_localizations.dart';

class Validator {
  static String? validateUsername(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.errorUsernameRequired;
    }
    return null;
  }

  static String? validatePassword(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.errorPasswordRequired;
    }
    if (value.length < 6) {
      return l10n.errorPasswordLength;
    }
    return null;
  }

  static String? validateWalletName(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.errorWalletNameRequired;
    }
    return null;
  }
}
