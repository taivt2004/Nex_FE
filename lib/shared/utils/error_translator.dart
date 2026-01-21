import 'package:nexpaylab/l10n/arb/app_localizations.dart';

extension AppLocalizationsErrorExt on AppLocalizations {
  String translateError(String errorKey) {
    switch (errorKey) {
      case 'errRequestCancelled':
        return errRequestCancelled;
      case 'errConnectionTimeout':
        return errConnectionTimeout;
      case 'errConnectionInterrupted':
        return errConnectionInterrupted;
      case 'errNetworkUnstable':
        return errNetworkUnstable;
      case 'errCertificate':
        return errCertificate;
      case 'errProcessFailed':
        return errProcessFailed;
      case 'errNoNewData':
        return errNoNewData;
      case 'errSystemBusy':
        return errSystemBusy;
      case 'errSessionExpired':
        return errSessionExpired;
      default:
        // If it's not a known key, return it as is (might be server message)
        return errorKey;
    }
  }
}
