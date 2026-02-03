import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/base/data_list.dart';
import 'package:nexpaylab/app/data/model/coin/coin_res.dart';
import 'package:nexpaylab/app/data/service/api.dart';
import 'package:nexpaylab/shared/utils/result.dart';

mixin CoinRepository {
  Future<Result<DataList<CoinRes>>> getCoinsRemote(int page, int limit);
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


}
