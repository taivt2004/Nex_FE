import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';
import 'package:nexpaylab/shared/constants/core_constants.dart';

part 'auth_check_event.dart';
part 'auth_check_state.dart';

@injectable
class AuthCheckBloc extends Bloc<AuthCheckEvent, AuthCheckState> {
  AuthCheckBloc(this._appConfigLocalStore) : super(const AuthCheckState()) {
    on<AuthCheckStarted>(_onAuthCheckStarted);
  }

  final AppConfigLocalStore _appConfigLocalStore;

  Future<void> _onAuthCheckStarted(
      AuthCheckStarted event, Emitter<AuthCheckState> emit) async {
    // Check Auth / Wallet
    final passphraseConfig = await _appConfigLocalStore
        .getConfigByKey(keyLocalPassphrase)
        .getSingleOrNull();

    if (passphraseConfig != null && passphraseConfig.value.isNotEmpty) {
      emit(state.copyWith(status: AuthCheckStatus.authenticated));
    } else {
      emit(state.copyWith(status: AuthCheckStatus.unauthenticated));
    }
  }
}
