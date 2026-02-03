part of 'auth_check_bloc.dart';

enum AuthCheckStatus { initial, authenticated, unauthenticated }

class AuthCheckState extends Equatable {
  const AuthCheckState({
    this.status = AuthCheckStatus.initial,
  });

  final AuthCheckStatus status;

  AuthCheckState copyWith({
    AuthCheckStatus? status,
  }) {
    return AuthCheckState(
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status];
}
