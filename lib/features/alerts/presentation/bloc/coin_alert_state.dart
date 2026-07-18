part of 'coin_alert_bloc.dart';

enum CoinAlertStatus {
  initial,
  loading,
  success,
  failure,
  submitting,
}

class CoinAlertState extends Equatable {
  const CoinAlertState({
    this.status = CoinAlertStatus.initial,
    this.coinId = '',
    this.coinName = '',
    this.coinSymbol = '',
    this.imageUrl = '',
    this.userId,
    this.userIdentity = '',
    this.requiresIdentity = false,
    this.alerts = const [],
    this.message = '',
    this.errorMessage = '',
  });

  final CoinAlertStatus status;
  final String coinId;
  final String coinName;
  final String coinSymbol;
  final String imageUrl;
  final int? userId;
  final String userIdentity;
  final bool requiresIdentity;
  final List<AlertSubscription> alerts;
  final String message;
  final String errorMessage;

  CoinAlertState copyWith({
    CoinAlertStatus? status,
    String? coinId,
    String? coinName,
    String? coinSymbol,
    String? imageUrl,
    int? userId,
    String? userIdentity,
    bool? requiresIdentity,
    List<AlertSubscription>? alerts,
    String? message,
    String? errorMessage,
  }) {
    return CoinAlertState(
      status: status ?? this.status,
      coinId: coinId ?? this.coinId,
      coinName: coinName ?? this.coinName,
      coinSymbol: coinSymbol ?? this.coinSymbol,
      imageUrl: imageUrl ?? this.imageUrl,
      userId: userId ?? this.userId,
      userIdentity: userIdentity ?? this.userIdentity,
      requiresIdentity: requiresIdentity ?? this.requiresIdentity,
      alerts: alerts ?? this.alerts,
      message: message ?? this.message,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        coinId,
        coinName,
        coinSymbol,
        imageUrl,
        userId,
        userIdentity,
        requiresIdentity,
        alerts,
        message,
        errorMessage,
      ];
}
