import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/service/api.dart';
import 'package:nexpaylab/app/data/service/model/coin_res.dart';
import 'package:nexpaylab/shared/utils/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin CoinRepository {
  Future<Result<CoinResponse>> getCoins(int page, int limit);
}

@Injectable(as: CoinRepository)
class CoinRepositoryImp implements CoinRepository {
  CoinRepositoryImp({required this.apiService});
  final ApiService apiService;
  static const _cacheTTLSeconds = 30;
  String _key(int page, int limit) => 'coin_cache_page_${page}_limit_$limit';
  String _tsKey(int page, int limit) => '${_key(page, limit)}_ts';

  @override
  Future<Result<CoinResponse>> getCoins(int page, int limit) async {
    return Result.guardFuture(() async {
      final prefs = await SharedPreferences.getInstance();
      CoinResponse? cached;
      final cachedStr = prefs.getString(_key(page, limit));
      final ts = prefs.getInt(_tsKey(page, limit)) ?? 0;
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final isFresh = (now - ts) <= _cacheTTLSeconds;
      if (cachedStr != null) {
        final map = jsonDecode(cachedStr) as Map<String, dynamic>;
        cached = CoinResponse.fromJson(map);
      }
      final res = await apiService.getCoins(page, limit);
      final hasData = res.total > 0 && res.items.isNotEmpty;
      if (hasData) {
        await prefs.setString(_key(page, limit), jsonEncode(res.toJson()));
        await prefs.setInt(_tsKey(page, limit), now);
        return res;
      }
      if (cached != null && isFresh) {
        return cached;
      }
      return res;
    });
  }
}
