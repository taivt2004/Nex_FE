import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/alert/alert_subscription.dart';
import 'package:nexpaylab/app/data/model/alert/create_alert_request.dart';
import 'package:nexpaylab/app/data/repository/alert_repos.dart';
import 'package:nexpaylab/shared/utils/result.dart';

part 'coin_alert_event.dart';
part 'coin_alert_state.dart';

@injectable
class CoinAlertBloc extends Bloc<CoinAlertEvent, CoinAlertState> {
  CoinAlertBloc(this._alertRepository) : super(const CoinAlertState()) {
    on<LoadCoinAlerts>(_onLoadCoinAlerts);
    on<SaveAlertIdentity>(_onSaveAlertIdentity);
    on<CreateCoinAlert>(_onCreateCoinAlert);
    on<ToggleCoinAlert>(_onToggleCoinAlert);
    on<DeleteCoinAlert>(_onDeleteCoinAlert);
    on<ClearCoinAlertMessage>(_onClearCoinAlertMessage);
  }

  final AlertRepository _alertRepository;

  Future<void> _onLoadCoinAlerts(
    LoadCoinAlerts event,
    Emitter<CoinAlertState> emit,
  ) async {
    emit(state.copyWith(
      status: CoinAlertStatus.loading,
      coinId: event.coinId,
      coinName: event.coinName,
      coinSymbol: event.coinSymbol,
      imageUrl: event.imageUrl,
      message: '',
      errorMessage: '',
    ));

    final identityResult = await _alertRepository.getStoredIdentity();
    final userIdResult = await _alertRepository.getStoredUserId();
    final identity = await identityResult.when(
      success: (value) async => value ?? '',
      failure: (_) async => '',
    );
    final userId = await userIdResult.when(
      success: (value) async => value,
      failure: (_) async => null,
    );

    if (userId == null) {
      emit(state.copyWith(
        status: CoinAlertStatus.success,
        userIdentity: identity,
        requiresIdentity: true,
        alerts: const [],
      ));
      return;
    }

    final alertsResult = await _alertRepository.getAlertsByCoin(userId, event.coinId);
    await alertsResult.when(
      success: (alerts) async {
        emit(state.copyWith(
          status: CoinAlertStatus.success,
          userId: userId,
          userIdentity: identity,
          requiresIdentity: false,
          alerts: alerts,
        ));
      },
      failure: (error) async {
        emit(state.copyWith(
          status: CoinAlertStatus.failure,
          userId: userId,
          userIdentity: identity,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  Future<void> _onSaveAlertIdentity(
    SaveAlertIdentity event,
    Emitter<CoinAlertState> emit,
  ) async {
    emit(state.copyWith(
      status: CoinAlertStatus.submitting,
      message: '',
      errorMessage: '',
    ));

    final loginResult = await _alertRepository.loginUser(event.identity);
    await loginResult.when(
      success: (user) async {
        emit(state.copyWith(
          status: CoinAlertStatus.success,
          userId: user.id,
          userIdentity: event.identity,
          requiresIdentity: false,
          message: 'Đã kết nối user alert',
        ));
        add(LoadCoinAlerts(
          coinId: state.coinId,
          coinName: state.coinName,
          coinSymbol: state.coinSymbol,
          imageUrl: state.imageUrl,
        ));
      },
      failure: (error) async {
        emit(state.copyWith(
          status: CoinAlertStatus.failure,
          requiresIdentity: true,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  Future<void> _onCreateCoinAlert(
    CreateCoinAlert event,
    Emitter<CoinAlertState> emit,
  ) async {
    final userId = state.userId;
    if (userId == null) {
      emit(state.copyWith(
        status: CoinAlertStatus.failure,
        requiresIdentity: true,
        errorMessage: 'Bạn cần kết nối user alert trước',
      ));
      return;
    }

    emit(state.copyWith(
      status: CoinAlertStatus.submitting,
      message: '',
      errorMessage: '',
    ));

    final result = await _alertRepository.createAlert(
      CreateAlertRequest(
        userId: userId,
        coinId: state.coinId,
        alertDirection: event.alertDirection,
        timeWindowMinutes: event.timeWindowMinutes,
        changePct: event.changePct,
        frequency: event.repeat ? 'repeat' : 'once',
        cooldownSeconds: 3600,
      ),
    );

    await result.when(
      success: (_) async {
        emit(state.copyWith(
          status: CoinAlertStatus.success,
          message: 'Đã lưu alert cho ${state.coinSymbol}',
        ));
        add(LoadCoinAlerts(
          coinId: state.coinId,
          coinName: state.coinName,
          coinSymbol: state.coinSymbol,
          imageUrl: state.imageUrl,
        ));
      },
      failure: (error) async {
        emit(state.copyWith(
          status: CoinAlertStatus.failure,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  Future<void> _onToggleCoinAlert(
    ToggleCoinAlert event,
    Emitter<CoinAlertState> emit,
  ) async {
    final result = await _alertRepository.updateAlert(
      event.id,
      isActive: event.isActive,
    );
    await result.when(
      success: (_) async {
        final alerts = state.alerts
            .map((item) => item.id == event.id
                ? AlertSubscription(
                    id: item.id,
                    userId: item.userId,
                    coinId: item.coinId,
                    changePct: item.changePct,
                    alertDirection: item.alertDirection,
                    frequency: item.frequency,
                    timeWindowMinutes: item.timeWindowMinutes,
                    cooldownSeconds: item.cooldownSeconds,
                    isActive: event.isActive,
                    conditionMet: item.conditionMet,
                    lastAlertAt: item.lastAlertAt,
                  )
                : item)
            .toList();
        emit(state.copyWith(
          alerts: alerts,
          message: event.isActive ? 'Đã bật alert' : 'Đã tắt alert',
          errorMessage: '',
        ));
      },
      failure: (error) async {
        emit(state.copyWith(
          errorMessage: error.toString(),
          message: '',
        ));
      },
    );
  }

  Future<void> _onDeleteCoinAlert(
    DeleteCoinAlert event,
    Emitter<CoinAlertState> emit,
  ) async {
    final result = await _alertRepository.deleteAlert(event.id);
    await result.when(
      success: (_) async {
        emit(state.copyWith(
          alerts: state.alerts.where((item) => item.id != event.id).toList(),
          message: 'Đã xoá alert',
          errorMessage: '',
        ));
      },
      failure: (error) async {
        emit(state.copyWith(
          errorMessage: error.toString(),
          message: '',
        ));
      },
    );
  }

  void _onClearCoinAlertMessage(
    ClearCoinAlertMessage event,
    Emitter<CoinAlertState> emit,
  ) {
    emit(state.copyWith(message: '', errorMessage: ''));
  }
}
