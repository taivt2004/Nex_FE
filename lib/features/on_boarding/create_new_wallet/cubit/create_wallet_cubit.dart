import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';

part 'create_wallet_state.dart';

class CreateWalletCubit extends Cubit<CreateWalletState> {
  CreateWalletCubit()
    : super(
        const CreateWalletState(
          walletName: 'Wallet 1',
          isSecure: false, 
          passphrase: '',
          confirmPassphrase: '',
        ),
      );

  void setWalletName(String value, {CreateWalletError? error}) {
    emit(state.copyWith(walletName: value, walletNameError: error));
  }

  void toggleSecure({required bool isSecure}) {
    emit(
      state.copyWith(
        isSecure: isSecure,
        // Reset error when toggling secure mode
        passphraseError: null,
        // Keep existing passphrase/confirm to allow user resume
      ),
    );
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
    CreateWalletError? error;
    if (s.isSecure &&
        s.passphrase.length == 6 &&
        s.confirmPassphrase.length == 6 &&
        s.passphrase != s.confirmPassphrase) {
      error = CreateWalletError.passphraseMismatch;
    }
    return s.copyWith(passphraseError: error);
  }

  Future<void> savePassphraseToDB(AppConfigLocalStore configStore) async {
    if (state.isSecure && state.passphrase.length == 6) {
      final createdAt = DateTime.now().toIso8601String();
      await configStore.saveValue('local_passphrase', state.passphrase);
      await configStore.saveValue('local_passphrase_created_at', createdAt);
    }
  }
}
