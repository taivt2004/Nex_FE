
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/coin/chart_data.dart';
import 'package:nexpaylab/app/data/model/coin/coin_detail.dart';
import 'package:nexpaylab/app/data/repository/coin_repos.dart';
import 'package:nexpaylab/shared/logger.dart';
import 'package:nexpaylab/shared/utils/result.dart';

part 'coin_detail_event.dart';
part 'coin_detail_state.dart';

enum ChartRange {
  h1('1h'),
  h24('24h'),
  d7('7d'),
  d30('30d'),
  y1('1y'),
  all('all');

  final String value;
  const ChartRange(this.value);
}

@injectable
class CoinDetailBloc extends Bloc<CoinDetailEvent, CoinDetailState> {
  CoinDetailBloc(this._coinRepository) : super(const CoinDetailState()) {
    on<FetchCoinDetail>(_onFetchDetail, transformer: droppable());
    on<FetchChartData>(_onFetchChart, transformer: droppable());
    on<ChangeChartRange>(_onChangeRange, transformer: droppable());
  }

  final CoinRepository _coinRepository;

  Future<void> _onFetchDetail(
    FetchCoinDetail event,
    Emitter<CoinDetailState> emit,
  ) async {
    emit(state.copyWith(
      detailStatus: CoinDetailStatus.loading,
      coinId: event.coinId,
    ));

    try {
      final detailResult = await _coinRepository.getCoinDetail(event.coinId);
      final chartResult = await _coinRepository.getChartData(event.coinId, range: state.chartRange.value);

      await detailResult.when(
        success: (CoinDetail detail) async {
          await chartResult.when(
            success: (ChartData chart) {
              emit(
                state.copyWith(
                  detailStatus: CoinDetailStatus.success,
                  coinDetail: detail,
                  chartData: chart,
                  chartStatus: ChartStatus.success,
                ),
              );
            },
            failure: (error) {
              emit(
                state.copyWith(
                  detailStatus: CoinDetailStatus.success,
                  coinDetail: detail,
                  chartStatus: ChartStatus.failure,
                  chartErrorMessage: error.toString(),
                ),
              );
            },
          );
        },
        failure: (error) {
          emit(
            state.copyWith(
              detailStatus: CoinDetailStatus.failure,
              detailErrorMessage: error.toString(),
            ),
          );
        },
      );
    } catch (e) {
      talker.error('CoinDetailBloc _onFetchDetail error', e);
      emit(
        state.copyWith(
          detailStatus: CoinDetailStatus.failure,
          detailErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onFetchChart(
    FetchChartData event,
    Emitter<CoinDetailState> emit,
  ) async {
    if (state.coinId == null) return;
    emit(state.copyWith(chartStatus: ChartStatus.loading));

    try {
      final chartResult = await _coinRepository.getChartData(
        state.coinId!,
        range: state.chartRange.value,
      );

      chartResult.when(
        success: (ChartData chart) {
          emit(
            state.copyWith(
              chartStatus: ChartStatus.success,
              chartData: chart,
            ),
          );
        },
        failure: (error) {
          emit(
            state.copyWith(
              chartStatus: ChartStatus.failure,
              chartErrorMessage: error.toString(),
            ),
          );
        },
      );
    } catch (e) {
      talker.error('CoinDetailBloc _onFetchChart error', e);
      emit(
        state.copyWith(
          chartStatus: ChartStatus.failure,
          chartErrorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onChangeRange(
    ChangeChartRange event,
    Emitter<CoinDetailState> emit,
  ) async {
    emit(state.copyWith(chartRange: event.range));
    add(FetchChartData());
  }
}
