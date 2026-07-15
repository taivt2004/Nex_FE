
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

enum ChartHistoryDirection { older, newer }

class FetchChartHistory extends CoinDetailEvent {
  const FetchChartHistory({
    required this.direction,
    this.timeStart,
    this.timeEnd,
  });

  final ChartHistoryDirection direction;
  final int? timeStart;
  final int? timeEnd;

  @override
  List<Object?> get props => [direction, timeStart, timeEnd];
}
