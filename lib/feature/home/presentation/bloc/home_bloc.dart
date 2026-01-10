import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/core/data/localstore/app.config.local.dart';
import 'package:nexpaylab/app/core/data/repository/app.config.repos.dart';
import 'package:nexpaylab/app/core/network.checker.dart';
import 'package:nexpaylab/app/core/network/exception.handler.dart';
import 'package:nexpaylab/app/core/user.session.dart';
import 'package:nexpaylab/feature/home/presentation/bloc/home_event.dart';
import 'package:nexpaylab/feature/home/presentation/bloc/home_state.dart';
import 'package:nexpaylab/share/logger.dart';
import 'package:nexpaylab/share/utils/result.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(
    this.appConfigRepository,
    this.networkChecker,
    this.appConfigLocalStore,
    this.userSession,
  ) : super(HomeInitial()) {
    on<HomeStarted>(onHomeStarted);
    on<LoadHomeConfig>(onLoadHomeConfig);
  }
  final UserSession userSession;
  final AppConfigLocalStore appConfigLocalStore;
  final AppConfigRepository appConfigRepository;
  final NetworkChecker networkChecker;

  Future<void> onHomeStarted(HomeStarted event, Emitter<HomeState> emit) async {
    networkChecker.observeNetworkStatus();
    final isLoggedIn = await userSession.isLoggedIn();
    if (!isLoggedIn) {
      talker.warning('onHomeStarted: Vui lòng đăng nhập để tiếp tục sử dụng.');
      return;
    }
    final isOnline = await networkChecker.isOnline();
    if (!isOnline) {
      talker.warning('onHomeStarted: Vui lòng kiểm tra kết nối mạng');
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
