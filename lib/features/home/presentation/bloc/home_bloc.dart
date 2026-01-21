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
  ) : super(HomeInitial()) {
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
    final isOnline = await networkChecker.isOnline();
    if (!isOnline) {
      talker.warning('onInitializeHome: Vui lòng kiểm tra kết nối mạng');
      return;
    }
  }

  Future<void> onLoadHomeConfig(
    LoadHomeConfig event,
    Emitter<HomeState> emit,
  ) async {
    final isOnline = await networkChecker.isOnline();
    if (!isOnline) {
      emit(HomeNetworkError(error: 'Vui lòng kiểm tra kết nối mạng.'));
      return;
    }

    if (event.showLoading) {
      emit(HomeLoading(message: 'Tải danh sách...'));
    }

    final results = await Future.wait([appConfigRepository.getAppConfigs()]);

    await results[0].when(
      success: (categories) async {
        emit(HomeSuccess());
      },
      failure: (fail) {
        if (fail is ExceptionHandler &&
            fail.serverity == ExceptServerity.normal) {
          emit(HomeSuccess());
        } else if (fail.toString().contains('Not Found')) {
          emit(HomeSuccess());
        } else {
          emit(HomeNetworkError(error: fail as String));
        }
      },
    );
  }
}
