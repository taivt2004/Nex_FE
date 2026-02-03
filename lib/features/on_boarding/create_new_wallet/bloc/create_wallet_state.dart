part of 'create_wallet_bloc.dart';

enum CreateWalletStatus { initial, submitting, success, failure }

enum CreateWalletError {
  walletNameRequired,
  walletNameLength,
  walletNameInvalid,
  passphraseMismatch,
}

class CreateWalletState extends Equatable {
  const CreateWalletState({
    this.walletName = '',
    this.isSecure = false,
    this.passphrase = '',
    this.confirmPassphrase = '',
    this.status = CreateWalletStatus.initial,
    this.walletNameError,
    this.passphraseError,
  });

  final String walletName;
  final bool isSecure;
  final String passphrase;
  final String confirmPassphrase;
  final CreateWalletStatus status;
  final CreateWalletError? walletNameError;
  final CreateWalletError? passphraseError;

  bool get isFormValid {
    if (walletNameError != null || walletName.isEmpty) return false;
    if (isSecure) {
      if (passphraseError != null || passphrase.isEmpty) return false;
      if (passphrase != confirmPassphrase) return false;
    }
    return true;
  }

  CreateWalletState copyWith({
    String? walletName,
    bool? isSecure,
    String? passphrase,
    String? confirmPassphrase,
    CreateWalletStatus? status,
    CreateWalletError? Function()? walletNameError,
    CreateWalletError? Function()? passphraseError,
  }) {
    return CreateWalletState(
      walletName: walletName ?? this.walletName,
      isSecure: isSecure ?? this.isSecure,
      passphrase: passphrase ?? this.passphrase,
      confirmPassphrase: confirmPassphrase ?? this.confirmPassphrase,
      status: status ?? this.status,
      walletNameError: walletNameError != null
          ? walletNameError()
          : this.walletNameError,
      passphraseError: passphraseError != null
          ? passphraseError()
          : this.passphraseError,
    );
  }

  @override
  List<Object?> get props => [
        walletName,
        isSecure,
        passphrase,
        confirmPassphrase,
        status,
        walletNameError,
        passphraseError,
      ];
}
