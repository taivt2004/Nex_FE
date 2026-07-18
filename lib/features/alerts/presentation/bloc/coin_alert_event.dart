part of 'coin_alert_bloc.dart';

abstract class CoinAlertEvent extends Equatable {
  const CoinAlertEvent();

  @override
  List<Object?> get props => [];
}

class LoadCoinAlerts extends CoinAlertEvent {
  const LoadCoinAlerts({
    required this.coinId,
    required this.coinName,
    required this.coinSymbol,
    required this.imageUrl,
  });

  final String coinId;
  final String coinName;
  final String coinSymbol;
  final String imageUrl;

  @override
  List<Object?> get props => [coinId, coinName, coinSymbol, imageUrl];
}

class SaveAlertIdentity extends CoinAlertEvent {
  const SaveAlertIdentity(this.identity);

  final String identity;

  @override
  List<Object?> get props => [identity];
}

class CreateCoinAlert extends CoinAlertEvent {
  const CreateCoinAlert({
    required this.alertDirection,
    required this.timeWindowMinutes,
    required this.changePct,
    required this.repeat,
  });

  final String alertDirection;
  final int timeWindowMinutes;
  final double changePct;
  final bool repeat;

  @override
  List<Object?> get props => [
        alertDirection,
        timeWindowMinutes,
        changePct,
        repeat,
      ];
}

class ToggleCoinAlert extends CoinAlertEvent {
  const ToggleCoinAlert({
    required this.id,
    required this.isActive,
  });

  final int id;
  final bool isActive;

  @override
  List<Object?> get props => [id, isActive];
}

class DeleteCoinAlert extends CoinAlertEvent {
  const DeleteCoinAlert(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class ClearCoinAlertMessage extends CoinAlertEvent {
  const ClearCoinAlertMessage();
}
