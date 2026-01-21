part of 'create_wallet_cubit.dart';

enum CreateWalletError {
  walletNameRequired,
  walletNameLength,
  walletNameInvalid,
  passphraseMismatch,
}

class CreateWalletState extends Equatable {
  const CreateWalletState({
    required this.walletName,
    required this.isSecure,
    required this.passphrase,
    required this.confirmPassphrase,
    this.walletNameError,
    this.passphraseError,
  });

  final String walletName;
  final bool isSecure;
  final String passphrase;
  final String confirmPassphrase;
  final CreateWalletError? walletNameError;
  final CreateWalletError? passphraseError;

  bool get showConfirm => isSecure && passphrase.length == 6;

  bool get isFormValid {
    if (walletNameError != null) return false;

    // Always require secure mode (passphrase)
    // if (!isSecure) return false; // Uncomment if checkbox itself is mandatory, but assuming logic is "must enter passphrase"

    // If secure mode is active (or if we want to force it):
    if (isSecure) {
      if (passphrase.length < 6) return false;
      if (confirmPassphrase.length < 6) return false;
      if (passphrase != confirmPassphrase) return false;
    } else {
      // If isSecure is false, disable button
      return false;
    }

    return true;
  }

  CreateWalletState copyWith({
    String? walletName,
    bool? isSecure,
    String? passphrase,
    String? confirmPassphrase,
    CreateWalletError? walletNameError,
    CreateWalletError? passphraseError,
    
  }) {
    return CreateWalletState(
      walletName: walletName ?? this.walletName,
      isSecure: isSecure ?? this.isSecure,
      passphrase: passphrase ?? this.passphrase,
      confirmPassphrase: confirmPassphrase ?? this.confirmPassphrase,
      walletNameError: walletNameError,
      passphraseError: passphraseError,
    );
  }

  @override
  List<Object?> get props => [
    walletName,
    isSecure,
    passphrase,
    confirmPassphrase,
    walletNameError,
    passphraseError,
  ];
}
