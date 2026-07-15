
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/coin/chart_data.dart';
import 'package:nexpaylab/app/data/model/coin/chart_history.dart';
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

  const ChartRange(this.value);
  final String value;
}

@injectable
class CoinDetailBloc extends Bloc<CoinDetailEvent, CoinDetailState> {
  CoinDetailBloc(this._coinRepository) : super(const CoinDetailState()) {
    on<FetchCoinDetail>(_onFetchDetail, transformer: droppable());
    on<FetchChartData>(_onFetchChart, transformer: droppable());
    on<ChangeChartRange>(_onChangeRange, transformer: droppable());
    on<FetchChartHistory>(_onFetchHistory, transformer: droppable());
  }

  final CoinRepository _coinRepository;
  final Set<String> _fetchedWindows = <String>{};

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
                  hasMoreOlderHistory: true,
                  hasMoreNewerHistory: true,
                  loadingOlderHistory: false,
                  loadingNewerHistory: false,
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
          _fetchedWindows.clear();
          emit(
            state.copyWith(
              chartStatus: ChartStatus.success,
              chartData: chart,
              chartErrorMessage: '',
              hasMoreOlderHistory: true,
              hasMoreNewerHistory: true,
              loadingOlderHistory: false,
              loadingNewerHistory: false,
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
    _fetchedWindows.clear();
    emit(state.copyWith(chartRange: event.range));
    add(const FetchChartData());
  }

  Future<void> _onFetchHistory(
    FetchChartHistory event,
    Emitter<CoinDetailState> emit,
  ) async {
    final chartData = state.chartData;
    final coinId = state.coinId;
    if (chartData == null || coinId == null || chartData.points.length < 2) {
      return;
    }

    final isOlder = event.direction == ChartHistoryDirection.older;
    if (isOlder) {
      if (state.loadingOlderHistory || !state.hasMoreOlderHistory) return;
      emit(state.copyWith(loadingOlderHistory: true));
    } else {
      if (state.loadingNewerHistory || !state.hasMoreNewerHistory) return;
      emit(state.copyWith(loadingNewerHistory: true));
    }

    final points = List<ChartPoint>.from(chartData.points)
      ..sort((a, b) => a.time.compareTo(b.time));
    final start = points.first.time;
    final end = points.last.time;
    final span = end - start;
    if (span <= 0) {
      emit(
        state.copyWith(
          loadingOlderHistory: false,
          loadingNewerHistory: false,
        ),
      );
      return;
    }

    final timeStart = event.timeStart ?? (isOlder ? start - span : end);
    final timeEnd = event.timeEnd ?? (isOlder ? start : end + span);
    final windowKey = '${state.chartRange.value}:$timeStart:$timeEnd';
    if (_fetchedWindows.contains(windowKey)) {
      emit(
        state.copyWith(
          loadingOlderHistory: false,
          loadingNewerHistory: false,
        ),
      );
      return;
    }
    _fetchedWindows.add(windowKey);

    try {
      final historyResult = await _coinRepository.getChartHistory(
        coinId,
        range: state.chartRange.value,
        timeStart: timeStart,
        timeEnd: timeEnd,
      );

      historyResult.when(
        success: (ChartHistory history) {
          _fetchedWindows.add(
            '${state.chartRange.value}:${history.timeStartAligned}:${history.timeEndAligned}',
          );
          final historyPoints = history.points
              .map((point) => ChartPoint(time: point.s, value: point.v.first))
              .toList();

          if (historyPoints.isEmpty) {
            emit(
              state.copyWith(
                loadingOlderHistory: false,
                loadingNewerHistory: false,
                hasMoreOlderHistory: !isOlder && state.hasMoreOlderHistory,
                hasMoreNewerHistory: isOlder && state.hasMoreNewerHistory,
              ),
            );
            return;
          }

          final mergedMap = <int, ChartPoint>{
            for (final point in chartData.points) point.time: point,
            for (final point in historyPoints) point.time: point,
          };
          final mergedPoints = mergedMap.values.toList()
            ..sort((a, b) => a.time.compareTo(b.time));

          emit(
            state.copyWith(
              chartData: ChartData(
                coinId: chartData.coinId,
                range: chartData.range,
                interval: history.interval.isEmpty
                    ? chartData.interval
                    : history.interval,
                baseLine: chartData.baseLine,
                points: mergedPoints,
              ),
              loadingOlderHistory: false,
              loadingNewerHistory: false,
            ),
          );
        },
        failure: (error) {
          talker.error('CoinDetailBloc _onFetchHistory failure', error);
          emit(
            state.copyWith(
              loadingOlderHistory: false,
              loadingNewerHistory: false,
            ),
          );
        },
      );
    } catch (e, s) {
      talker.error('CoinDetailBloc _onFetchHistory error', e, s);
      emit(
        state.copyWith(
          loadingOlderHistory: false,
          loadingNewerHistory: false,
        ),
      );
    }
  }
}
