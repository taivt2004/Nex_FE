import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/alert/alert_event_item.dart';
import 'package:nexpaylab/app/data/model/alert/alert_user.dart';
import 'package:nexpaylab/app/data/repository/alert_repos.dart';
import 'package:nexpaylab/shared/utils/result.dart';

part 'alert_events_event.dart';
part 'alert_events_state.dart';

@injectable
class AlertEventsBloc extends Bloc<AlertEventsEvent, AlertEventsState> {
  AlertEventsBloc(this._alertRepository) : super(const AlertEventsState()) {
    on<LoadAlertEvents>(_onLoadAlertEvents);
    on<SaveAlertEventsIdentity>(_onSaveAlertEventsIdentity);
    on<ClearAlertEventsMessage>(_onClearAlertEventsMessage);
  }

  final AlertRepository _alertRepository;

  Future<void> _onLoadAlertEvents(
    LoadAlertEvents event,
    Emitter<AlertEventsState> emit,
  ) async {
    emit(state.copyWith(
      status: AlertEventsStatus.loading,
      message: '',
      errorMessage: '',
    ));

    final identityResult = await _alertRepository.getStoredIdentity();
    final userIdResult = await _alertRepository.getStoredUserId();
    final identity = identityResult.maybeWhen(
      success: (value) => value ?? '',
      orElse: () => '',
    );
    final userId = userIdResult.maybeWhen(
      success: (value) => value,
      orElse: () => null,
    );

    if (userId == null) {
      emit(state.copyWith(
        status: AlertEventsStatus.success,
        requiresIdentity: true,
        identity: identity,
        events: const [],
      ));
      return;
    }

    final eventsResult = await _alertRepository.getAlertEvents(userId, limit: event.limit);
    eventsResult.when(
      success: (List<AlertEventItem> events) {
        emit(state.copyWith(
          status: AlertEventsStatus.success,
          requiresIdentity: false,
          userId: userId,
          identity: identity,
          events: events,
        ));
      },
      failure: (error) {
        emit(state.copyWith(
          status: AlertEventsStatus.failure,
          requiresIdentity: false,
          userId: userId,
          identity: identity,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  Future<void> _onSaveAlertEventsIdentity(
    SaveAlertEventsIdentity event,
    Emitter<AlertEventsState> emit,
  ) async {
    emit(state.copyWith(
      status: AlertEventsStatus.submitting,
      message: '',
      errorMessage: '',
    ));

    final loginResult = await _alertRepository.loginUser(event.identity);
    loginResult.when(
      success: (AlertUser user) {
        emit(state.copyWith(
          status: AlertEventsStatus.success,
          requiresIdentity: false,
          userId: user.id,
          identity: event.identity,
          message: 'Đã kết nối user alert',
        ));
        add(const LoadAlertEvents());
      },
      failure: (error) {
        emit(state.copyWith(
          status: AlertEventsStatus.failure,
          requiresIdentity: true,
          errorMessage: error.toString(),
        ));
      },
    );
  }

  void _onClearAlertEventsMessage(
    ClearAlertEventsMessage event,
    Emitter<AlertEventsState> emit,
  ) {
    emit(state.copyWith(message: '', errorMessage: ''));
  }
}
