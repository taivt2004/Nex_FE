part of 'alert_events_bloc.dart';

enum AlertEventsStatus {
  initial,
  loading,
  success,
  failure,
  submitting,
}

class AlertEventsState extends Equatable {
  const AlertEventsState({
    this.status = AlertEventsStatus.initial,
    this.userId,
    this.identity = '',
    this.requiresIdentity = false,
    this.events = const [],
    this.message = '',
    this.errorMessage = '',
  });

  final AlertEventsStatus status;
  final int? userId;
  final String identity;
  final bool requiresIdentity;
  final List<AlertEventItem> events;
  final String message;
  final String errorMessage;

  AlertEventsState copyWith({
    AlertEventsStatus? status,
    int? userId,
    String? identity,
    bool? requiresIdentity,
    List<AlertEventItem>? events,
    String? message,
    String? errorMessage,
  }) {
    return AlertEventsState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      identity: identity ?? this.identity,
      requiresIdentity: requiresIdentity ?? this.requiresIdentity,
      events: events ?? this.events,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        userId,
        identity,
        requiresIdentity,
        events,
        message,
        errorMessage,
      ];
}
