import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';

part 'create_wallet_event.dart';
part 'create_wallet_state.dart';

const String keyLocalPassphrase = 'local_passphrase';
const String keyLocalPassphraseCreatedAt = 'local_passphrase_created_at';

class CreateWalletBloc extends Bloc<CreateWalletEvent, CreateWalletState> {
  CreateWalletBloc(this._appConfigStore) : super(const CreateWalletState()) {
    on<WalletNameChanged>(_onWalletNameChanged);
    on<SecureToggled>(_onSecureToggled);
    on<PassphraseChanged>(_onPassphraseChanged);
    on<ConfirmPassphraseChanged>(_onConfirmPassphraseChanged);
    on<CreateWalletSubmitted>(_onCreateWalletSubmitted);
  }

  final AppConfigLocalStore _appConfigStore;

  void _onWalletNameChanged(
    WalletNameChanged event,
    Emitter<CreateWalletState> emit,
  ) {
    final walletName = event.walletName;
    CreateWalletError? error;

    if (walletName.isEmpty) {
      error = CreateWalletError.walletNameRequired;
    } else if (walletName.length > 20) {
      error = CreateWalletError.walletNameLength;
    } else if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(walletName)) {
      error = CreateWalletError.walletNameInvalid;
    }

    emit(
      state.copyWith(
        walletName: walletName,
        walletNameError: () => error,
      ),
    );
  }

  void _onSecureToggled(
    SecureToggled event,
    Emitter<CreateWalletState> emit,
  ) {
    emit(state.copyWith(isSecure: event.isSecure));
  }

  void _onPassphraseChanged(
    PassphraseChanged event,
    Emitter<CreateWalletState> emit,
  ) {
    emit(state.copyWith(passphrase: event.passphrase));
    add(ConfirmPassphraseChanged(state.confirmPassphrase));
  }

  void _onConfirmPassphraseChanged(
    ConfirmPassphraseChanged event,
    Emitter<CreateWalletState> emit,
  ) {
    final confirmPassphrase = event.confirmPassphrase;
    CreateWalletError? error;

    if (state.isSecure && confirmPassphrase != state.passphrase) {
      error = CreateWalletError.passphraseMismatch;
    }

    emit(
      state.copyWith(
        confirmPassphrase: confirmPassphrase,
        passphraseError: () => error,
      ),
    );
  }

  Future<void> _onCreateWalletSubmitted(
    CreateWalletSubmitted event,
    Emitter<CreateWalletState> emit,
  ) async {
    if (!state.isFormValid) return;

    emit(state.copyWith(status: CreateWalletStatus.submitting));

    try {
      if (state.isSecure) {
        final createdAt = DateTime.now().toIso8601String();
        await _appConfigStore.saveValue(keyLocalPassphrase, state.passphrase);
        await _appConfigStore.saveValue(
          keyLocalPassphraseCreatedAt,
          createdAt,
        );
      }
      emit(state.copyWith(status: CreateWalletStatus.success));
    } catch (_) {
      emit(state.copyWith(status: CreateWalletStatus.failure));
    }
  }
}
