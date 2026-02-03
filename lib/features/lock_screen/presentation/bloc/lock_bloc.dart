
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';
import 'package:nexpaylab/shared/constants/core_constants.dart';

part 'lock_event.dart';
part 'lock_state.dart';

@injectable
class LockBloc extends Bloc<LockEvent, LockState> {
  LockBloc(this._configStore) : super(const LockState()) {
    on<LockStarted>(_onStarted);
    on<PassphraseChanged>(_onPassphraseInput);
    on<ResetWalletConfirmed>(_onResetConfirmed);
  }

  final AppConfigLocalStore _configStore;

  // Checks if the wallet is already set up (has a passphrase).
  Future<void> _onStarted(LockStarted event, Emitter<LockState> emit) async {
    final result = await _configStore.getConfigByKey(keyLocalPassphrase).getSingleOrNull();
    final passphrase = result?.value;
    
    if (passphrase == null || passphrase.isEmpty) {
      emit(state.copyWith(status: LockStatus.unauthenticated));
    } else {
      emit(state.copyWith(status: LockStatus.initial));
    }
  }

  // Handles PIN input.
  // - If length < 6: Clears error state and updates UI.
  // - If length == 6: Triggers verification.
  Future<void> _onPassphraseInput(PassphraseChanged event, Emitter<LockState> emit) async {
    // Reset error state while typing
    if (event.passphrase.length < 6) {
      emit(state.copyWith(status: LockStatus.initial, error: LockError.none));
      return;
    }

    // Verify when 6 digits are entered
    await _verifyPassphrase(event.passphrase, emit);
  }

  // Verifies the entered passphrase against the stored one.
  Future<void> _verifyPassphrase(String enteredPassphrase, Emitter<LockState> emit) async {
    emit(state.copyWith(status: LockStatus.authenticating));

    final result = await _configStore.getConfigByKey(keyLocalPassphrase).getSingleOrNull();
    final storedPassphrase = result?.value;
    
    if (storedPassphrase == enteredPassphrase) {
      emit(state.copyWith(status: LockStatus.authenticated));
    } else {
      emit(state.copyWith(
        status: LockStatus.initial,
        error: LockError.incorrectPassphrase,
      ));
    }
  }

  Future<void> _onResetConfirmed(
    ResetWalletConfirmed event,
    Emitter<LockState> emit,
  ) async {
    // TODO: Implement actual wallet reset logic here
    await _configStore.clearConfigAll();
    emit(state.copyWith(status: LockStatus.resetDone));
  }
}
