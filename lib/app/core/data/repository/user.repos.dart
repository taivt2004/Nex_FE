import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/core/data/localstore/app.config.local.dart';
import 'package:nexpaylab/app/core/data/localstore/user.local.dart';
import 'package:nexpaylab/app/core/data/model/app.config.dart';
import 'package:nexpaylab/app/core/data/model/user.dart';
import 'package:nexpaylab/app/core/data/service/api.dart';
import 'package:nexpaylab/app/core/data/service/param/login.param.dart';
import 'package:nexpaylab/app/core/data/service/param/register.param.dart';
import 'package:nexpaylab/constants.dart';
import 'package:nexpaylab/share/utils/result.dart';

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
          .login(LoginParam(username: username, password: password));
      final user = res.user;
      unawaited(userLocalStore.saveOrUpdateUser(user));
      unawaited(
        appConfigLocalStore.saveInBatch(
          [
            ConfigItem(key: tokenKey, value: res.token),
            ConfigItem(key: userKey, value: user.id.toString()),
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
          .register(RegisterParam(username: username, password: password));
      final user = res.user;
      unawaited(userLocalStore.saveOrUpdateUser(user));
      unawaited(
        appConfigLocalStore.saveInBatch(
          [
            ConfigItem(key: tokenKey, value: res.token),
            ConfigItem(key: userKey, value: user.id.toString()),
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
