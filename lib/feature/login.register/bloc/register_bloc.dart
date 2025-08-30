import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/core/data/repository/user.repos.dart';
import 'package:nexpaylab/app/core/user.session.dart';
import 'package:nexpaylab/feature/login.register/bloc/register_event.dart';
import 'package:nexpaylab/feature/login.register/bloc/register_state.dart';
import 'package:nexpaylab/share/logger.dart';
import 'package:nexpaylab/share/utils/result.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc(this.userRepository, this.userSession)
    : super(RegisterInitial()) {
    on<RegisterButtonPressed>(onRegister);
  }

  final UserRepository userRepository;
  final UserSession userSession;

  Future<void> onRegister(
    RegisterButtonPressed event,
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
