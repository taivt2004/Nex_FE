import 'dart:async';  

import 'package:flutter_bloc/flutter_bloc.dart';  
import 'package:nexpaylab/app/data/repository/user_repos.dart';  
import 'package:nexpaylab/app/session/user_session.dart';  
import 'package:nexpaylab/features/auth/presentation/bloc/login_event.dart';
import 'package:nexpaylab/features/auth/presentation/bloc/login_state.dart'; 
import 'package:nexpaylab/shared/logger.dart';
import 'package:nexpaylab/shared/utils/result.dart';  

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.userRepository, this.userSession) : super(LoginInitial()) {
    on<SubmitLogin>(onLogin);  
  }

  final UserSession userSession;  
  final UserRepository userRepository;  

  Future<void> onLogin(
    SubmitLogin event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());  
  
    final result = await userRepository.login(event.username, event.password);  
    
    result.when(  
      success: (user) { 
        talker.debug('login success: $user');  
        unawaited(userSession.reloadUser(user));  
        emit(LoginSuccess()); 
      },
      failure: (error) {  
        talker.debug('login failure: $error');  
        emit(LoginFailure(error: error.toString()));  
      },
    );
  }
} 
