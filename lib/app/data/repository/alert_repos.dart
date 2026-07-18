import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/alert/alert_event_item.dart';
import 'package:nexpaylab/app/data/model/alert/alert_subscription.dart';
import 'package:nexpaylab/app/data/model/alert/alert_user.dart';
import 'package:nexpaylab/app/data/model/alert/create_alert_request.dart';
import 'package:nexpaylab/app/data/service/alert_api.dart';
import 'package:nexpaylab/app/data/service/local_storage_service.dart';
import 'package:nexpaylab/shared/utils/result.dart';

const _alertUserIdKey = 'alert_user_id';
const _alertUserIdentityKey = 'alert_user_identity';

mixin AlertRepository {
  Future<Result<AlertUser>> loginUser(String identity);
  Future<Result<int?>> getStoredUserId();
  Future<Result<String?>> getStoredIdentity();
  Future<Result<void>> logoutUser();
  Future<Result<AlertSubscription>> createAlert(CreateAlertRequest request);
  Future<Result<List<AlertSubscription>>> getAlertsByCoin(int userId, String coinId);
  Future<Result<List<AlertEventItem>>> getAlertEvents(int userId, {int limit = 50});
  Future<Result<AlertSubscription>> updateAlert(
    int id, {
    double? changePct,
    String? frequency,
    int? cooldownSeconds,
    bool? isActive,
  });
  Future<Result<bool>> deleteAlert(int id);
}

@Injectable(as: AlertRepository)
class AlertRepositoryImp implements AlertRepository {
  AlertRepositoryImp({
    required AlertApiService alertApiService,
    required LocalStorageService localStorageService,
  })  : _alertApiService = alertApiService,
        _localStorageService = localStorageService;

  final AlertApiService _alertApiService;
  final LocalStorageService _localStorageService;

  @override
  Future<Result<int?>> getStoredUserId() async {
    return Result.guardFuture(() async {
      final raw = _localStorageService.getString(_alertUserIdKey);
      if (raw == null || raw.isEmpty) return null;
      return int.tryParse(raw);
    });
  }

  @override
  Future<Result<String?>> getStoredIdentity() async {
    return Result.guardFuture(() async {
      return _localStorageService.getString(_alertUserIdentityKey);
    });
  }

  @override
  Future<Result<void>> logoutUser() async {
    return Result.guardFuture(() async {
      await _localStorageService.remove(_alertUserIdKey);
      await _localStorageService.remove(_alertUserIdentityKey);
    });
  }

  @override
  Future<Result<AlertUser>> loginUser(String identity) async {
    return Result.guardFuture(() async {
      final trimmed = identity.trim();
      final response = await _alertApiService.login(
        email: trimmed.contains('@') ? trimmed : null,
        externalId: trimmed.contains('@') ? null : trimmed,
      );
      final success = response['success'] == true;
      if (!success) {
        throw Exception(response['message']?.toString() ?? 'Đăng nhập alert thất bại');
      }
      final data = response['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
      final user = AlertUser.fromJson(data);
      await _localStorageService.saveString(_alertUserIdKey, user.id.toString());
      await _localStorageService.saveString(_alertUserIdentityKey, trimmed);
      return user;
    });
  }

  @override
  Future<Result<AlertSubscription>> createAlert(CreateAlertRequest request) async {
    return Result.guardFuture(() async {
      final response = await _alertApiService.createAlert(request);
      final success = response['success'] == true;
      if (!success) {
        throw Exception(response['message']?.toString() ?? 'Tạo alert thất bại');
      }
      final data = response['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
      return AlertSubscription.fromCreateOrUpdateJson(data);
    });
  }

  @override
  Future<Result<List<AlertSubscription>>> getAlertsByCoin(int userId, String coinId) async {
    return Result.guardFuture(() async {
      final response = await _alertApiService.getUserAlertsByCoin(userId, coinId);
      final success = response['success'] == true;
      if (!success) {
        throw Exception(response['message']?.toString() ?? 'Lấy alert thất bại');
      }
      final rawList = response['data'] as List<dynamic>? ?? <dynamic>[];
      return rawList
          .map((item) => AlertSubscription.fromListJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<Result<List<AlertEventItem>>> getAlertEvents(int userId, {int limit = 50}) async {
    return Result.guardFuture(() async {
      final response = await _alertApiService.getAlertEvents(userId, limit: limit);
      final success = response['success'] == true;
      if (!success) {
        throw Exception(response['message']?.toString() ?? 'Lấy thông báo thất bại');
      }
      final rawList = response['data'] as List<dynamic>? ?? <dynamic>[];
      return rawList
          .map((item) => AlertEventItem.fromJson(item as Map<String, dynamic>))
          .toList();
    });
  }

  @override
  Future<Result<AlertSubscription>> updateAlert(
    int id, {
    double? changePct,
    String? frequency,
    int? cooldownSeconds,
    bool? isActive,
  }) async {
    return Result.guardFuture(() async {
      final payload = <String, dynamic>{
        if (changePct != null) 'changePct': changePct,
        if (frequency != null) 'frequency': frequency,
        if (cooldownSeconds != null) 'cooldownSeconds': cooldownSeconds,
        if (isActive != null) 'isActive': isActive,
      };
      final response = await _alertApiService.updateAlert(id, payload);
      final success = response['success'] == true;
      if (!success) {
        throw Exception(response['message']?.toString() ?? 'Cập nhật alert thất bại');
      }
      final data = response['data'] as Map<String, dynamic>? ?? <String, dynamic>{};
      return AlertSubscription.fromCreateOrUpdateJson(data);
    });
  }

  @override
  Future<Result<bool>> deleteAlert(int id) async {
    return Result.guardFuture(() async {
      final response = await _alertApiService.deleteAlert(id);
      return response['success'] == true;
    });
  }
}
