import 'dart:async';  // Cho Future/Stream

import 'package:flutter_bloc/flutter_bloc.dart';  // Core Bloc
import 'package:injectable/injectable.dart';  // @injectable: Trigger DI gen
import 'package:nexpaylab/app/core/data/repository/user.repos.dart';  // UserRepository (abstract?)
import 'package:nexpaylab/app/core/user.session.dart';  // UserSession
import 'package:nexpaylab/feature/login.register/bloc/login_event.dart';  // Events (e.g., LoginButtonPressed)
import 'package:nexpaylab/feature/login.register/bloc/login_state.dart';  // States (Initial/Loading/Success/Failure)
import 'package:nexpaylab/share/logger.dart';  // talker.debug() cho log
import 'package:nexpaylab/share/utils/result.dart';  // Result (Either<Success, Failure>)

@injectable  // ← DI ANNOTATION: Injectable sẽ gen code để register Bloc này như factory (tạo mới mỗi lần dùng, phù hợp Bloc)
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // ← CONSTRUCTOR INJECTION: DI tự inject 2 deps này
  LoginBloc(this.userRepository, this.userSession) : super(LoginInitial()) {
    on<LoginButtonPressed>(onLogin);  // Register event handler
  }

  final UserSession userSession;  // ← DEP 1: Inject UserSession (singleton/lazy từ AppModule hoặc @injectable)
  final UserRepository userRepository;  // ← DEP 2: Inject UserRepository (factory, inject LocalStore/ApiService từ config.dart)

  Future<void> onLogin(  // Event handler: Async để await Repo call
    LoginButtonPressed event,  // Event từ UI (e.g., button press với username/password)
    Emitter<LoginState> emit,  // Bloc Emitter để emit states
  ) async {
    emit(LoginLoading());  // Emit loading state (UI show spinner)
  
    final result = await userRepository.login(event.username, event.password);  // ← DI SỬ DỤNG: Gọi Repo (đã inject)
    
    result.when(  // Handle Result (success/failure – pattern phổ biến trong Clean Arch)
      success: (user) {  // Success case
        talker.debug('login success: $user');  // Log với talker
        unawaited(userSession.reloadUser(user));  // Reload session (non-blocking)
        emit(LoginSuccess());  // Emit success state (UI navigate home)
      },
      failure: (error) {  // Failure case
        talker.debug('login failure: $error');  // Log error
        emit(LoginFailure(error: error.toString()));  // Emit error state (UI show snackbar)
      },
    );
  }
}