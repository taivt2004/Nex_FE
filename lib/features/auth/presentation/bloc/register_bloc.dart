import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/repository/user_repos.dart';
import 'package:nexpaylab/app/session/user_session.dart';
import 'package:nexpaylab/features/auth/presentation/bloc/register_event.dart';
import 'package:nexpaylab/features/auth/presentation/bloc/register_state.dart';
import 'package:nexpaylab/shared/logger.dart';
import 'package:nexpaylab/shared/utils/result.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this.userRepository, this.userSession)
    : super(RegisterInitial()) {
    on<RegisterSubmitted>(onRegister);
  }

  final UserRepository userRepository;
  final UserSession userSession;

  Future<void> onRegister(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    final result = await userRepository.register(
      event.username,
      event.password,
    );
    result.when(
      success: (user) {
        talker.debug('register success: $user');
        unawaited(userSession.reloadUser(user));
        emit(RegisterSuccess());
      },
      failure: (error) {
        talker.debug('register failure: $error');
        emit(RegisterFailure(error: error as String));
      },
    );
  }
}
