part of 'splash_bloc.dart';

enum SplashStatus { initial, loading, updateRequired, authenticated, unauthenticated, failure }

class SplashState {
  const SplashState({
    this.status = SplashStatus.initial,
    this.errorMessage,
    this.storeUrl,
    this.isForceUpdate = false,
  });

  final SplashStatus status;
  final String? errorMessage;
  final String? storeUrl;
  final bool isForceUpdate;

  SplashState copyWith({
    SplashStatus? status,
    String? errorMessage,
    String? storeUrl,
    bool? isForceUpdate,
  }) {
    return SplashState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      storeUrl: storeUrl ?? this.storeUrl,
      isForceUpdate: isForceUpdate ?? this.isForceUpdate,
    );
  }
}
