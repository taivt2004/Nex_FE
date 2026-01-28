import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/base/base_response.dart';
import 'package:nexpaylab/app/data/model/coin/coin.dart';
import 'package:nexpaylab/app/data/service/api.dart';
import 'package:nexpaylab/shared/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin CoinRepository {
  Future<Result<BaseResponse<List<Coin>>>> getCoinsRemote(int page, int limit);
  Future<BaseResponse<List<Coin>>?> getCoinsLocal(int page, int limit);
  Future<void> saveCoinsLocal(int page, int limit, BaseResponse<List<Coin>> data);
  Future<int> getLastFetchTime(int page, int limit);
}

@Injectable(as: CoinRepository)
class CoinRepositoryImp implements CoinRepository {
  CoinRepositoryImp({required this.apiService});
  final ApiService apiService;
  
  String _key(int page, int limit) => 'coin_cache_page_${page}_limit_$limit';
  String _tsKey(int page, int limit) => '${_key(page, limit)}_ts';

  @override
  Future<Result<BaseResponse<List<Coin>>>> getCoinsRemote(int page, int limit) async {
    return Result.guardFuture(() {
      return apiService.getCoins(page, limit);
    });
  }

  @override
  Future<BaseResponse<List<Coin>>?> getCoinsLocal(int page, int limit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _key(page, limit);
      final cachedStr = prefs.getString(key);
      
      if (cachedStr != null) {
        final dynamic decoded = jsonDecode(cachedStr);
        
        // Robustness check: If cache is not a Map, clear it.
        if (decoded is! Map<String, dynamic>) {
          await prefs.remove(key);
          await prefs.remove(_tsKey(page, limit));
          return null;
        }

        return BaseResponse.fromJson(
          decoded,
          (json) => (json as List<dynamic>?)!
              .map((item) => Coin.fromJson(item as Map<String, dynamic>))
              .toList(),
        );
      }
    } catch (_) {
      // If any error occurs (e.g. jsonDecode error or type mismatch), just ignore and return null
    }
    return null;
  }
  
  @override
  Future<void> saveCoinsLocal(int page, int limit, BaseResponse<List<Coin>> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      await prefs.setString(
        _key(page, limit),
        jsonEncode(
          data.toJson(
            (list) => list.map((coin) => coin.toJson()).toList(),
          ),
        ),
      );
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
