part of 'already_have_wallet_cubit.dart';

class AlreadyHaveWalletState {
  const AlreadyHaveWalletState({
    this.walletName = 'Wallet 1',
    this.secretPhrase = '',
    this.isSecure = false,
    this.passphrase = '',
    this.walletNameError,
  });

  final String walletName;
  final String secretPhrase;
  final bool isSecure;
  final String passphrase;
  final String? walletNameError;

  bool get isSecretValid {
    final text = secretPhrase.trim();
    if (text.isEmpty) return false;
    final words = text.split(RegExp(r'\s+'));
    return words.length == 12;
  }

  AlreadyHaveWalletState copyWith({
    String? walletName,
    String? secretPhrase,
    bool? isSecure,
    String? passphrase,
    String? walletNameError,
  }) {
    return AlreadyHaveWalletState(
      walletName: walletName ?? this.walletName,
      secretPhrase: secretPhrase ?? this.secretPhrase,
      isSecure: isSecure ?? this.isSecure,
      passphrase: passphrase ?? this.passphrase,
      walletNameError: walletNameError,
    );
  }
}
