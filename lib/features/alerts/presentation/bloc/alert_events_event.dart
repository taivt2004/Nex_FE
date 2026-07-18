part of 'alert_events_bloc.dart';

abstract class AlertEventsEvent extends Equatable {
  const AlertEventsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAlertEvents extends AlertEventsEvent {
  const LoadAlertEvents({this.limit = 50});

  final int limit;

  @override
  List<Object?> get props => [limit];
}

class SaveAlertEventsIdentity extends AlertEventsEvent {
  const SaveAlertEventsIdentity(this.identity);

  final String identity;

  @override
  List<Object?> get props => [identity];
}

class ClearAlertEventsMessage extends AlertEventsEvent {
  const ClearAlertEventsMessage();
}
