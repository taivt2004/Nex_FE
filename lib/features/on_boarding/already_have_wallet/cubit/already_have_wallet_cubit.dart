import 'package:flutter_bloc/flutter_bloc.dart';

part 'already_have_wallet_state.dart';

class AlreadyHaveWalletCubit extends Cubit<AlreadyHaveWalletState> {
  AlreadyHaveWalletCubit() : super(const AlreadyHaveWalletState());

  void setWalletName(String name, {AlreadyHaveWalletError? error}) {
    emit(state.copyWith(walletName: name, walletNameError: error));
  }

  void setSecretPhrase(String phrase) {
    emit(state.copyWith(secretPhrase: phrase));
  }

  void toggleSecure({required bool isSecure}) {
    emit(state.copyWith(isSecure: isSecure));
  }

  void setPassphrase(String passphrase) {
    emit(state.copyWith(passphrase: passphrase));
  }
}
