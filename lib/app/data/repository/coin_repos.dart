import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/service/api.dart';
import 'package:nexpaylab/app/data/service/model/coin_res.dart';
import 'package:nexpaylab/shared/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin CoinRepository {
  Future<Result<CoinRes>> getCoinsRemote(int page, int limit);
  Future<CoinRes?> getCoinsLocal(int page, int limit);
  Future<void> saveCoinsLocal(int page, int limit, CoinRes data);
  Future<int> getLastFetchTime(int page, int limit);
}

@Injectable(as: CoinRepository)
class CoinRepositoryImp implements CoinRepository {
  CoinRepositoryImp({required this.apiService});
  final ApiService apiService;
  
  String _key(int page, int limit) => 'coin_cache_page_${page}_limit_$limit';
  String _tsKey(int page, int limit) => '${_key(page, limit)}_ts';

  @override
  Future<Result<CoinRes>> getCoinsRemote(int page, int limit) async {
    return Result.guardFuture(() async {
      return apiService.getCoins(page, limit);
    });
  }

  @override
  Future<CoinRes?> getCoinsLocal(int page, int limit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedStr = prefs.getString(_key(page, limit));
      if (cachedStr != null) {
        final map = jsonDecode(cachedStr) as Map<String, dynamic>;
        return CoinRes.fromJson(map);
      }
    } catch (_) {}
    return null;
  }

  @override
  Future<void> saveCoinsLocal(int page, int limit, CoinRes data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await prefs.setString(_key(page, limit), jsonEncode(data.toJson()));
      await prefs.setInt(_tsKey(page, limit), now);
    } catch (_) {}
  }

  @override
  Future<int> getLastFetchTime(int page, int limit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_tsKey(page, limit)) ?? 0;
    } catch (_) {
      return 0;
    }
  }
}
