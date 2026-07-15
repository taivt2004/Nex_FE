
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
    this.loadingOlderHistory = false,
    this.loadingNewerHistory = false,
    this.hasMoreOlderHistory = true,
    this.hasMoreNewerHistory = true,
  });

  final CoinDetailStatus detailStatus;
  final ChartStatus chartStatus;
  final CoinDetail? coinDetail;
  final ChartData? chartData;
  final String? coinId;
  final ChartRange chartRange;
  final String detailErrorMessage;
  final String chartErrorMessage;
  final bool loadingOlderHistory;
  final bool loadingNewerHistory;
  final bool hasMoreOlderHistory;
  final bool hasMoreNewerHistory;

  CoinDetailState copyWith({
    CoinDetailStatus? detailStatus,
    ChartStatus? chartStatus,
    CoinDetail? coinDetail,
    ChartData? chartData,
    String? coinId,
    ChartRange? chartRange,
    String? detailErrorMessage,
    String? chartErrorMessage,
    bool? loadingOlderHistory,
    bool? loadingNewerHistory,
    bool? hasMoreOlderHistory,
    bool? hasMoreNewerHistory,
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
      loadingOlderHistory: loadingOlderHistory ?? this.loadingOlderHistory,
      loadingNewerHistory: loadingNewerHistory ?? this.loadingNewerHistory,
      hasMoreOlderHistory: hasMoreOlderHistory ?? this.hasMoreOlderHistory,
      hasMoreNewerHistory: hasMoreNewerHistory ?? this.hasMoreNewerHistory,
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
        loadingOlderHistory,
        loadingNewerHistory,
        hasMoreOlderHistory,
        hasMoreNewerHistory,
      ];
}
