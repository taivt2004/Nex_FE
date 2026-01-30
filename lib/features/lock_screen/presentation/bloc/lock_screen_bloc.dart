
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';
import 'package:nexpaylab/shared/constants/core_constants.dart';

part 'lock_screen_event.dart';
part 'lock_screen_state.dart';
@injectable
class LockBloc extends Bloc<LockScreenEvent, LockScreenState> {
  LockBloc(this._configStore) : super(const LockScreenState()) {
    on<LockStarted>(_onStarted);
    on<PassphraseChanged>(_onChanged);
    on<PassphraseSubmitted>(_onSubmitted);
    on<ResetWalletConfirmed>(_onResetConfirmed);
  }

  final AppConfigLocalStore _configStore;


  Future<void> _onStarted(LockStarted e, Emitter<LockScreenState> emit) async {
    final result = await _configStore.getConfigByKey(keyLocalPassphrase)
    .getSingleOrNull();
    if(result == null) {
      emit(state.copyWith(status: LockStatus.unauthenticated, isLoading: false));
    }else {
      emit(state.copyWith(storedPassphrase: result.value, status: LockStatus.initial, isLoading: false));
    }
  }


  void _onChanged(PassphraseChanged e, Emitter<LockScreenState> emit) {
    if (state.error != LockError.none) {
      emit(state.copyWith(error: LockError.none));
    }
  }

  void _onSubmitted(PassphraseSubmitted e, Emitter<LockScreenState> emit) {
    if (e.value == state.storedPassphrase) {
      emit(state.copyWith(status: LockStatus.authenticated));
    } else {
      emit(state.copyWith(error: LockError.incorrectPassphrase));
    }
  }

  Future<void> _onResetConfirmed(ResetWalletConfirmed e, Emitter<LockScreenState> emit) async {
    await _configStore.clearConfigAll();
    emit(state.copyWith(status: LockStatus.resetDone));
  }
}
