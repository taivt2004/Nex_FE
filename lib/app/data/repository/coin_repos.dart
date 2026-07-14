import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/base/data_list.dart';
import 'package:nexpaylab/app/data/model/coin/chart_data.dart';
import 'package:nexpaylab/app/data/model/coin/chart_history.dart';
import 'package:nexpaylab/app/data/model/coin/coin_detail.dart';
import 'package:nexpaylab/app/data/model/coin/coin_list_item.dart';
import 'package:nexpaylab/app/data/model/coin/coin_res.dart';
import 'package:nexpaylab/app/data/service/api.dart';
import 'package:nexpaylab/shared/utils/result.dart';

mixin CoinRepository {
  Future<Result<DataList<CoinRes>>> getCoinsRemote(int page, int limit);
  Future<Result<DataList<CoinListItem>>> getCoinList({
    int page = 1,
    String limit = '100',
  });
  Future<Result<CoinDetail>> getCoinDetail(String id);
  Future<Result<ChartData>> getChartData(String id, {String range = '1h'});
  Future<Result<ChartHistory>> getChartHistory(
    String id, {
    required String range,
    required int timeStart,
    required int timeEnd,
  });
}

@Injectable(as: CoinRepository)
class CoinRepositoryImp implements CoinRepository {
  CoinRepositoryImp({required this.apiService});
  final ApiService apiService;
  
  @override
  Future<Result<DataList<CoinRes>>> getCoinsRemote(int page, int limit) async {
    return Result.guardFuture(() async {
      final res = await apiService.getCoins(page, limit);
      return DataList(
        data: res.data ?? [],
        meta: res.meta,
      );
    });
  }

  @override
  Future<Result<DataList<CoinListItem>>> getCoinList({
    int page = 1,
    String limit = '100',
  }) async {
    return Result.guardFuture(() async {
      final res = await apiService.getCoinList(page: page, limit: limit);
      return DataList(
        data: res.data ?? [],
        meta: res.meta,
      );
    });
  }

  @override
  Future<Result<CoinDetail>> getCoinDetail(String id) async {
    return Result.guardFuture(() async {
      final res = await apiService.getCoinDetail(id);
      if (res.data == null) {
        throw Exception('No data');
      }
      return res.data!;
    });
  }

  @override
  Future<Result<ChartData>> getChartData(String id, {String range = '1h'}) async {
    return Result.guardFuture(() async {
      final res = await apiService.getChartData(id, range: range);
      if (res.data == null) {
        throw Exception('No data');
      }
      return res.data!;
    });
  }

  @override
  Future<Result<ChartHistory>> getChartHistory(
    String id, {
    required String range,
    required int timeStart,
    required int timeEnd,
  }) async {
    return Result.guardFuture(() async {
      final res = await apiService.getChartHistory(
        id,
        range: range,
        timeStart: timeStart,
        timeEnd: timeEnd,
      );
      if (res.data == null) {
        throw Exception('No data');
      }
      return res.data!;
    });
  }
}
