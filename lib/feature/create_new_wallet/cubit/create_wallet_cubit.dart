import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'create_wallet_state.dart';

class CreateWalletCubit extends Cubit<CreateWalletState> {
  CreateWalletCubit()
      : super(const CreateWalletState(
          walletName: 'Wallet 1',
          isSecure: false,
          passphrase: '',
          confirmPassphrase: '',
        ));

  void setWalletName(String value) {
    final error = _validateWalletName(value);
    emit(state.copyWith(walletName: value, walletNameError: error));
  }

  void toggleSecure(bool value) {
    emit(state.copyWith(
      isSecure: value,
      // Reset error when toggling secure mode
      passphraseError: null,
      // Keep existing passphrase/confirm to allow user resume
    ));
  }

  void setPassphrase(String value) {
    final next = state.copyWith(passphrase: value);
    emit(_withPassphraseError(next));
  }

  void setConfirmPassphrase(String value) {
    final next = state.copyWith(confirmPassphrase: value);
    emit(_withPassphraseError(next));
  }

  CreateWalletState _withPassphraseError(CreateWalletState s) {
    String? error;
    if (s.isSecure &&
        s.passphrase.length == 6 &&
        s.confirmPassphrase.length == 6 &&
        s.passphrase != s.confirmPassphrase) {
      error = 'Passphrase do not match';
    }
    return s.copyWith(passphraseError: error);
  }

  String? _validateWalletName(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Wallet name cannot be empty';
    }
    if (trimmed.length > 24) {
      return 'Max 24 characters';
    }
    final valid = RegExp(r'^[A-Za-z0-9 ]+$');
    if (!valid.hasMatch(trimmed)) {
      return 'Only letters, numbers and spaces are allowed';
    }
    return null;
  }
}
