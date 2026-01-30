part of 'lock_screen_bloc.dart';


enum LockStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
  resetDone,
}

enum LockError { incorrectPassphrase, none }

class LockScreenState {
  const LockScreenState({
    this.status = LockStatus.initial,
    this.storedPassphrase,
    this.error = LockError.none,
    this.isLoading = false,
  });

  final LockStatus status;
  final String? storedPassphrase;
  final LockError error;
  final bool isLoading;

  LockScreenState copyWith({
    LockStatus? status,
    String? storedPassphrase,
    LockError? error,
    bool? isLoading,
  }) => LockScreenState(
      status: status ?? this.status,
      storedPassphrase: storedPassphrase ?? this.storedPassphrase,
      error: error ?? this.error,
      isLoading: isLoading ?? this.isLoading,
    );
  
}
