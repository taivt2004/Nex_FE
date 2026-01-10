import 'package:flutter_bloc/flutter_bloc.dart';

part 'already_have_wallet_state.dart';

class AlreadyHaveWalletCubit extends Cubit<AlreadyHaveWalletState> {
  AlreadyHaveWalletCubit() : super(const AlreadyHaveWalletState());

  void setWalletName(String name) {
    emit(state.copyWith(walletName: name));
  }

  void setSecretPhrase(String phrase) {
    emit(state.copyWith(secretPhrase: phrase));
  }

  void toggleSecure(bool isSecure) {
    emit(state.copyWith(isSecure: isSecure));
  }

  void setPassphrase(String passphrase) {
    emit(state.copyWith(passphrase: passphrase));
  }

  void validateWalletName() {
    final name = state.walletName.trim();
    final error = name.isEmpty ? 'Wallet name is required' : null;
    emit(state.copyWith(walletNameError: error));
  }
}
