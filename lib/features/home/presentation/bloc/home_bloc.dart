import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/repository/app_config_repos.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';
import 'package:nexpaylab/app/network/exception_handler.dart';
import 'package:nexpaylab/app/network/network_checker.dart';
import 'package:nexpaylab/app/session/user_session.dart';
import 'package:nexpaylab/features/home/presentation/bloc/home_event.dart';
import 'package:nexpaylab/features/home/presentation/bloc/home_state.dart';
import 'package:nexpaylab/shared/logger.dart';
import 'package:nexpaylab/shared/utils/result.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this.appConfigRepository,
    this.networkChecker,
    this.appConfigLocalStore,
    this.userSession,
  ) : super(const HomeState()) {
    on<InitializeHome>(onInitializeHome);
    on<LoadHomeConfig>(onLoadHomeConfig);
  }
  final UserSession userSession;
  final AppConfigLocalStore appConfigLocalStore;
  final AppConfigRepository appConfigRepository;
  final NetworkChecker networkChecker;

  Future<void> onInitializeHome(InitializeHome event, Emitter<HomeState> emit) async {
    networkChecker.observeNetworkStatus();
    final isLoggedIn = await userSession.isLoggedIn();
    if (!isLoggedIn) {
      talker.warning('onInitializeHome: Vui lòng đăng nhập để tiếp tục sử dụng.');
      return;
    }

    add(LoadHomeConfig(showLoading: false));
  }

  Future<void> onLoadHomeConfig(
    LoadHomeConfig event,
    Emitter<HomeState> emit,
  ) async {
    final isOnline = await networkChecker.isOnline();
    if (!isOnline) {
      // If not online, then use local data
      return;
    }

    if (event.showLoading) {
      emit(state.copyWith(status: HomeStatus.loading));
    }

    
    final result = await appConfigRepository.getAppConfigs(['f_swap', 'f_product']);
    
    await result.when(
      success: (configs) async {
        emit(state.copyWith(status: HomeStatus.success));
      },
      failure: (fail) {
        if (fail is ExceptionHandler &&
            fail.serverity == ExceptServerity.normal) {
           emit(state.copyWith(status: HomeStatus.success));
        } else if (fail.toString().contains('Not Found')) {
           emit(state.copyWith(status: HomeStatus.success));
        } else {
           
           emit(state.copyWith(
             status: HomeStatus.failure, 
             errorMessage: fail.toString()
           ));
        }
      },
    );
  }
}
