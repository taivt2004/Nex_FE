import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/base/data_list.dart';
import 'package:nexpaylab/app/data/model/base/meta.dart';
import 'package:nexpaylab/app/data/model/coin/coin_res.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 1. Định nghĩa Interface
mixin CoinLocal {
  Future<DataList<CoinRes>?> getCoinsLocal(int page, int limit);
  Future<void> saveCoinsLocal(int page, int limit, DataList<CoinRes> data);
  Future<int> getLastFetchTime(int page, int limit);
}

// 2. Implementation
@Injectable(as: CoinLocal)
class CoinLocalImp implements CoinLocal {
  
  // Helper tạo key cho cache
  String _key(int page, int limit) => 'coin_cache_page_${page}_limit_$limit';
  String _tsKey(int page, int limit) => '${_key(page, limit)}_ts';

  @override
  Future<DataList<CoinRes>?> getCoinsLocal(int page, int limit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final key = _key(page, limit);
      final cachedStr = prefs.getString(key);
      
      if (cachedStr != null) {
        final dynamic decoded = jsonDecode(cachedStr);
        
        // check data is valid
        if (decoded is! Map<String, dynamic>) {
          await prefs.remove(key);
          await prefs.remove(_tsKey(page, limit));
          return null;
        }
        
        final dataList = (decoded['data'] as List<dynamic>?)
            ?.map((item) => CoinRes.fromJson(item as Map<String, dynamic>))
            .toList() ?? [];
            
        final metaJson = decoded['meta'] as Map<String, dynamic>?;
        final meta = metaJson != null ? Meta.fromJson(metaJson) : null;

        return DataList(data: dataList, meta: meta);
      }
    } catch (_) {}
    return null;
  }
  
  @override
  Future<void> saveCoinsLocal(int page, int limit, DataList<CoinRes> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      
      final mapToSave = {
        'data': data.data.map((coin) => coin.toJson()).toList(),
        'meta': data.meta?.toJson(),
      };

      await prefs.setString(
        _key(page, limit),
        jsonEncode(mapToSave),
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
