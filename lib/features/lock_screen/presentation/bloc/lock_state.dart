part of 'lock_bloc.dart';

enum LockStatus { initial, authenticating, authenticated, unauthenticated, resetDone }
enum LockError { none, incorrectPassphrase }

class LockState extends Equatable {
  const LockState({
    this.status = LockStatus.initial,
    this.error = LockError.none,
  });

  final LockStatus status;
  final LockError error;

  LockState copyWith({
    LockStatus? status,
    LockError? error,
  }) {
    return LockState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, error];
}
