import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/app_config.dart';
import 'package:nexpaylab/app/data/model/user.dart';
import 'package:nexpaylab/app/data/service/api.dart';
import 'package:nexpaylab/app/data/service/param/login_req.dart';
import 'package:nexpaylab/app/data/service/param/register_req.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';
import 'package:nexpaylab/app/database/user_local.dart';
import 'package:nexpaylab/shared/constants/core_constants.dart';
import 'package:nexpaylab/shared/utils/result.dart';

mixin UserRepository {
  Future<Result<User>> login(String username, String password);
  Future<Result<User>> register(String username, String password);
  Future<Result<int>> logout();
}

@Injectable(as: UserRepository)
class UserRepositoryImp implements UserRepository {
  UserRepositoryImp(
    this.userLocalStore, {
    required this.appConfigLocalStore,
    required this.apiService,
  });
  
  final AppConfigLocalStore appConfigLocalStore;
  final ApiService apiService;
  final UserLocalStore userLocalStore;

  @override
  Future<Result<User>> login(String username, String password) async {
    return Result.guardFuture(() async {
      final res = await apiService
          .login(LoginReq(username: username, password: password));
      final user = res.user;
      unawaited(userLocalStore.saveOrUpdateUser(user));
      unawaited(
        appConfigLocalStore.saveInBatch(
          [
            ConfigItemRes(key: tokenKey, value: res.token),
            ConfigItemRes(key: userKey, value: user.id.toString()),
          ],
        ),
      );
      return res.user;
    });
  }

  @override
  Future<Result<User>> register(String username, String password) async {
    return Result.guardFuture(() async {
      final res = await apiService
          .register(RegisterReq(username: username, password: password));
      final user = res.user;
      unawaited(userLocalStore.saveOrUpdateUser(user));
      unawaited(
        appConfigLocalStore.saveInBatch(
          [
            ConfigItemRes(key: tokenKey, value: res.token),
            ConfigItemRes(key: userKey, value: user.id.toString()),
          ],
        ),
      );
      return res.user;
    });
  }

  @override
  Future<Result<int>> logout() async {
    return Result.guardFuture(() async {
      final userId = await apiService.logout();
      return userId;
    });
  }
}
