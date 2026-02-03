import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'arb/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('vi'),
  ];

  /// Text shown in the AppBar of the Counter Page
  ///
  /// In en, this message translates to:
  /// **'Counter'**
  String get counterAppBarTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @swap.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get swap;

  /// No description provided for @trending.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trending;

  /// No description provided for @discover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discover;

  /// No description provided for @totalValue.
  ///
  /// In en, this message translates to:
  /// **'Total value'**
  String get totalValue;

  /// No description provided for @actionSend.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get actionSend;

  /// No description provided for @actionReceive.
  ///
  /// In en, this message translates to:
  /// **'Receive'**
  String get actionReceive;

  /// No description provided for @actionBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get actionBuy;

  /// No description provided for @actionSwap.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get actionSwap;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Scan QR to pay'**
  String get payment;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Please login to continue'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account to use full features'**
  String get registerTitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @usernameHint.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameHint;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password at least 6 characters'**
  String get passwordLabel;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @createAccountAction.
  ///
  /// In en, this message translates to:
  /// **'CREATE ACCOUNT'**
  String get createAccountAction;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @errorUsernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get errorUsernameRequired;

  /// No description provided for @errorPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get errorPasswordRequired;

  /// No description provided for @errorPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get errorPasswordLength;

  /// No description provided for @loginAction.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get loginAction;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get noAccount;

  /// No description provided for @registerAction.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerAction;

  /// No description provided for @loginAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get loginAppBarTitle;

  /// No description provided for @dialogBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get dialogBack;

  /// No description provided for @dialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get dialogConfirm;

  /// No description provided for @dialogClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get dialogClose;

  /// No description provided for @errRequestCancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get errRequestCancelled;

  /// No description provided for @errConnectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout'**
  String get errConnectionTimeout;

  /// No description provided for @errConnectionInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Connection interrupted. Please check your network'**
  String get errConnectionInterrupted;

  /// No description provided for @errNetworkUnstable.
  ///
  /// In en, this message translates to:
  /// **'Network unstable'**
  String get errNetworkUnstable;

  /// No description provided for @errCertificate.
  ///
  /// In en, this message translates to:
  /// **'Certificate error'**
  String get errCertificate;

  /// No description provided for @errProcessFailed.
  ///
  /// In en, this message translates to:
  /// **'Processing failed'**
  String get errProcessFailed;

  /// No description provided for @errNoNewData.
  ///
  /// In en, this message translates to:
  /// **'No new data'**
  String get errNoNewData;

  /// No description provided for @errSystemBusy.
  ///
  /// In en, this message translates to:
  /// **'System busy. Please try again later'**
  String get errSystemBusy;

  /// No description provided for @errSessionExpired.
  ///
  /// In en, this message translates to:
  /// **'Session expired. Please login again'**
  String get errSessionExpired;

  /// No description provided for @lockScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Passphrase'**
  String get lockScreenTitle;

  /// No description provided for @lockScreenSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock your wallet to continue'**
  String get lockScreenSubtitle;

  /// No description provided for @incorrectPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Incorrect passphrase'**
  String get incorrectPassphrase;

  /// No description provided for @forgotPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Forgot Passphrase?'**
  String get forgotPassphrase;

  /// No description provided for @resetWalletTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Wallet?'**
  String get resetWalletTitle;

  /// No description provided for @resetWalletMessage.
  ///
  /// In en, this message translates to:
  /// **'This will wipe all wallet data from this device. You will need your Secret Phrase to recover your wallet.'**
  String get resetWalletMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @trendingTitle.
  ///
  /// In en, this message translates to:
  /// **'Trending'**
  String get trendingTitle;

  /// No description provided for @swapTitle.
  ///
  /// In en, this message translates to:
  /// **'Swap'**
  String get swapTitle;

  /// No description provided for @discoverTitle.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get discoverTitle;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @registerAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'REGISTER ACCOUNT'**
  String get registerAppBarTitle;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Private First,\nSecure and Effortless'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Manage your crypto with absolute privacy and ease.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Privacy First'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'With Open Source and Self Custody Key Management — audited for privacy, built for your full control.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Strong Security'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Trusted Execution Environment (TEE) secures encrypted data with hardware-level protection.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Simple & Fast'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'NexPay\'s clean, intuitive interface makes money management effortless.'**
  String get onboardingDesc4;

  /// No description provided for @createNewWallet.
  ///
  /// In en, this message translates to:
  /// **'Create new wallet'**
  String get createNewWallet;

  /// No description provided for @alreadyHaveWallet.
  ///
  /// In en, this message translates to:
  /// **'I already have a wallet'**
  String get alreadyHaveWallet;

  /// No description provided for @termsOfServiceConsent.
  ///
  /// In en, this message translates to:
  /// **'By tapping above button, you agree and consent to our '**
  String get termsOfServiceConsent;

  /// No description provided for @and.
  ///
  /// In en, this message translates to:
  /// **' and '**
  String get and;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @secretPhraseTitle.
  ///
  /// In en, this message translates to:
  /// **'What\'s a Secret Phrase?'**
  String get secretPhraseTitle;

  /// No description provided for @secretPhraseDesc1.
  ///
  /// In en, this message translates to:
  /// **'A Secret Phrase is a human-readable list of 12 words generated by NexPay. Example (12-word Secret Phrase): gravity machine north sort system female filter attitude volume fold club stay'**
  String get secretPhraseDesc1;

  /// No description provided for @secretPhraseDesc2.
  ///
  /// In en, this message translates to:
  /// **'For added protection, NexPay combines your Secret Phrase with an additional Passphrase, creating multi-layered security to prevent unauthorized access or leakage.'**
  String get secretPhraseDesc2;

  /// No description provided for @secretPhraseAgree1.
  ///
  /// In en, this message translates to:
  /// **'Only you know this secret phrase. If someone else has seen it, they can steal your funds'**
  String get secretPhraseAgree1;

  /// No description provided for @secretPhraseAgree2.
  ///
  /// In en, this message translates to:
  /// **'If you lose it, NexPay can\'t restore your funds'**
  String get secretPhraseAgree2;

  /// No description provided for @walletName.
  ///
  /// In en, this message translates to:
  /// **'Wallet name'**
  String get walletName;

  /// No description provided for @secureYourWallet.
  ///
  /// In en, this message translates to:
  /// **'Secure your wallet with a Passphrase'**
  String get secureYourWallet;

  /// No description provided for @confirmPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Confirm Passphrase'**
  String get confirmPassphrase;

  /// No description provided for @passphraseInfo.
  ///
  /// In en, this message translates to:
  /// **'Passphrase is used to secure your Wallet\'s Secret phrase, creating multi-layered security to prevent unauthorized access or leakage.'**
  String get passphraseInfo;

  /// No description provided for @enterPassphrase.
  ///
  /// In en, this message translates to:
  /// **'Enter Passphrase (if your wallet has)'**
  String get enterPassphrase;

  /// No description provided for @restoreWallet.
  ///
  /// In en, this message translates to:
  /// **'Restore wallet'**
  String get restoreWallet;

  /// No description provided for @addExistingWallet.
  ///
  /// In en, this message translates to:
  /// **'Add existing wallet'**
  String get addExistingWallet;

  /// No description provided for @continueAction.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueAction;

  /// No description provided for @createAction.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get createAction;

  /// No description provided for @secretPhraseLabel.
  ///
  /// In en, this message translates to:
  /// **'Secret phrase'**
  String get secretPhraseLabel;

  /// No description provided for @paste.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get paste;

  /// No description provided for @secretPhraseHint.
  ///
  /// In en, this message translates to:
  /// **'Typically 12 words separated by single spaces'**
  String get secretPhraseHint;

  /// No description provided for @paymentCoffeeShop.
  ///
  /// In en, this message translates to:
  /// **'Coffee shop'**
  String get paymentCoffeeShop;

  /// No description provided for @paymentTemplate.
  ///
  /// In en, this message translates to:
  /// **'Template d..'**
  String get paymentTemplate;

  /// No description provided for @paymentShopOnline.
  ///
  /// In en, this message translates to:
  /// **'Shop online'**
  String get paymentShopOnline;

  /// No description provided for @paymentPayBills.
  ///
  /// In en, this message translates to:
  /// **'Pay bills'**
  String get paymentPayBills;

  /// No description provided for @checkNetworkConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your network connection'**
  String get checkNetworkConnection;

  /// No description provided for @errorWalletNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Wallet name is required'**
  String get errorWalletNameRequired;

  /// No description provided for @errorWalletNameLength.
  ///
  /// In en, this message translates to:
  /// **'Max 20 characters'**
  String get errorWalletNameLength;

  /// No description provided for @errorWalletNameInvalid.
  ///
  /// In en, this message translates to:
  /// **'Only letters, numbers and spaces are allowed'**
  String get errorWalletNameInvalid;

  /// No description provided for @errorPassphraseMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passphrase do not match'**
  String get errorPassphraseMismatch;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Tiếng Việt'**
  String get vietnamese;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get spanish;

  /// No description provided for @errNetworkConnection.
  ///
  /// In en, this message translates to:
  /// **'Please check your network connection'**
  String get errNetworkConnection;

  /// No description provided for @updateApp.
  ///
  /// In en, this message translates to:
  /// **'Update application'**
  String get updateApp;

  /// No description provided for @updateAppContent.
  ///
  /// In en, this message translates to:
  /// **'The current version is outdated. Please update to continue using it.'**
  String get updateAppContent;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @updateNow.
  ///
  /// In en, this message translates to:
  /// **'Update now'**
  String get updateNow;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
