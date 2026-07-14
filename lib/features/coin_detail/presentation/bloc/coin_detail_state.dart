
part of 'coin_detail_bloc.dart';

enum CoinDetailStatus { initial, loading, success, failure }
enum ChartStatus { initial, loading, success, failure }

class CoinDetailState extends Equatable {
  const CoinDetailState({
    this.detailStatus = CoinDetailStatus.initial,
    this.chartStatus = ChartStatus.initial,
    this.coinDetail,
    this.chartData,
    this.coinId,
    this.chartRange = ChartRange.h1,
    this.detailErrorMessage = '',
    this.chartErrorMessage = '',
  });

  final CoinDetailStatus detailStatus;
  final ChartStatus chartStatus;
  final CoinDetail? coinDetail;
  final ChartData? chartData;
  final String? coinId;
  final ChartRange chartRange;
  final String detailErrorMessage;
  final String chartErrorMessage;

  CoinDetailState copyWith({
    CoinDetailStatus? detailStatus,
    ChartStatus? chartStatus,
    CoinDetail? coinDetail,
    ChartData? chartData,
    String? coinId,
    ChartRange? chartRange,
    String? detailErrorMessage,
    String? chartErrorMessage,
  }) {
    return CoinDetailState(
      detailStatus: detailStatus ?? this.detailStatus,
      chartStatus: chartStatus ?? this.chartStatus,
      coinDetail: coinDetail ?? this.coinDetail,
      chartData: chartData ?? this.chartData,
      coinId: coinId ?? this.coinId,
      chartRange: chartRange ?? this.chartRange,
      detailErrorMessage: detailErrorMessage ?? this.detailErrorMessage,
      chartErrorMessage: chartErrorMessage ?? this.chartErrorMessage,
    );
  }

  @override
  List<Object?> get props => [
        detailStatus,
        chartStatus,
        coinDetail,
        chartData,
        coinId,
        chartRange,
        detailErrorMessage,
        chartErrorMessage,
      ];
}
