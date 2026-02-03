part of 'already_have_wallet_bloc.dart';

abstract class AlreadyHaveWalletEvent extends Equatable {
  const AlreadyHaveWalletEvent();

  @override
  List<Object?> get props => [];
}

class WalletNameChanged extends AlreadyHaveWalletEvent {
  const WalletNameChanged(this.walletName, {this.error});

  final String walletName;
  final AlreadyHaveWalletError? error;

  @override
  List<Object?> get props => [walletName, error];
}

class SecretPhraseChanged extends AlreadyHaveWalletEvent {
  const SecretPhraseChanged(this.secretPhrase);

  final String secretPhrase;

  @override
  List<Object?> get props => [secretPhrase];
}

class SecureToggled extends AlreadyHaveWalletEvent {
  const SecureToggled({required this.isSecure});

  final bool isSecure;

  @override
  List<Object?> get props => [isSecure];
}

class PassphraseChanged extends AlreadyHaveWalletEvent {
  const PassphraseChanged(this.passphrase);

  final String passphrase;

  @override
  List<Object?> get props => [passphrase];
}
