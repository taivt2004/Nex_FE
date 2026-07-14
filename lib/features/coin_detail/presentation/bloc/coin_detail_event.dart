
part of 'coin_detail_bloc.dart';

abstract class CoinDetailEvent extends Equatable {
  const CoinDetailEvent();

  @override
  List<Object?> get props => [];
}

class FetchCoinDetail extends CoinDetailEvent {
  const FetchCoinDetail({required this.coinId});

  final String coinId;

  @override
  List<Object?> get props => [coinId];
}

class FetchChartData extends CoinDetailEvent {
  const FetchChartData();
}

class ChangeChartRange extends CoinDetailEvent {
  const ChangeChartRange({required this.range});

  final ChartRange range;

  @override
  List<Object?> get props => [range];
}
