part of 'create_wallet_bloc.dart';

abstract class CreateWalletEvent extends Equatable {
  const CreateWalletEvent();

  @override
  List<Object> get props => [];
}

class WalletNameChanged extends CreateWalletEvent {
  const WalletNameChanged(this.walletName);

  final String walletName;

  @override
  List<Object> get props => [walletName];
}

class SecureToggled extends CreateWalletEvent {
  const SecureToggled({required this.isSecure});

  final bool isSecure;

  @override
  List<Object> get props => [isSecure];
}

class PassphraseChanged extends CreateWalletEvent {
  const PassphraseChanged(this.passphrase);

  final String passphrase;

  @override
  List<Object> get props => [passphrase];
}

class ConfirmPassphraseChanged extends CreateWalletEvent {
  const ConfirmPassphraseChanged(this.confirmPassphrase);

  final String confirmPassphrase;

  @override
  List<Object> get props => [confirmPassphrase];
}

class CreateWalletSubmitted extends CreateWalletEvent {
  const CreateWalletSubmitted();
}
