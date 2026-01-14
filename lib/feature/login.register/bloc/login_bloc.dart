import 'dart:async';  

import 'package:flutter_bloc/flutter_bloc.dart';  
import 'package:nexpaylab/app/core/data/repository/user.repos.dart';  
import 'package:nexpaylab/app/core/user.session.dart';  
import 'package:nexpaylab/feature/login.register/bloc/login_event.dart';  
import 'package:nexpaylab/feature/login.register/bloc/login_state.dart'; 
import 'package:nexpaylab/share/logger.dart';
import 'package:nexpaylab/share/utils/result.dart';  

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this.userRepository, this.userSession) : super(LoginInitial()) {
    on<LoginButtonPressed>(onLogin);  
  }

  final UserSession userSession;  
  final UserRepository userRepository;  

  Future<void> onLogin(
    LoginButtonPressed event,
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
