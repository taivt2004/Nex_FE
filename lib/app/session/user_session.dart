// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:nexpaylab/app/data/model/user/user.dart';
import 'package:nexpaylab/app/database/app_config_local.dart';
import 'package:nexpaylab/app/database/user_local.dart';
import 'package:nexpaylab/shared/constants/core_constants.dart';
import 'package:nexpaylab/shared/logger.dart';
import 'package:nexpaylab/shared/utils/cache.dart';
import 'package:nexpaylab/shared/utils/scope_functions_dart.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

@lazySingleton
class UserSessionStream {
  final _userInfoSubject = BehaviorSubject<User?>();
  final _userStatusSubject = BehaviorSubject<bool>();

  void Function(User? user) get broascastUser => _userInfoSubject.sink.add;
  void Function(bool status) get broascastUserStatus =>
      _userStatusSubject.sink.add;

  ValueStream<User?> get userInfoStream => _userInfoSubject.stream;
  ValueStream<bool> get userStatusStream => _userStatusSubject.stream;

  void dispose() {
    _userInfoSubject.close();
    _userStatusSubject.close();
  }
}

@lazySingleton
class UserSession {
  UserSession(
    this.appConfigRepository,
    this.userStream,
    this.userRepository,
  ) {
    start();
  }
  
  final UserSessionStream userStream;
  final AppConfigLocalStore appConfigRepository;
  final UserLocalStore userRepository;

  User? _user;

  User? get currentUser => _user;

  void _notify(User? user) {
    userStream.broascastUser(user);
    userStream.broascastUserStatus(user != null);
  }

  Future<bool> isLoggedIn() async {
    if (_user != null) {
      return Future.value(true);
    }
    return Future.value(false);
  }

  Future<void> clearSession() async {
    await appConfigRepository.clearConfig(userKey);
    await appConfigRepository.clearConfig(tokenKey);

    await _user?.let((user) async {
      await userRepository.deleteUser(user.id);
      _user = null;
      _notify(_user);
    });
    await deleteCacheDir();
  }

  Future<void> start() async {
    //reload user session from db
    _user = await loadCurrentUser();
    talker.debug('start with user ${_user?.toJson()}');
    if (_user == null) {
      _notify(null);
      return;
    }
    _notify(_user);
  }

  Future<User?> loadCurrentUser() async {
    final config =
        await appConfigRepository.getConfigByKey(userKey).getSingleOrNull();
    if (config?.value.isEmpty ?? true) {
      talker.debug('user session is empty');
      return Future.value(null);
    }
    final userId = int.parse(config!.value);
    return reloadUserWithId(userId);
  }

  Future<void> reloadUser(User user) async {
    _user = user;
    _notify(user);
  }

  Future<User?> reloadUserWithId(int userId) async {
    final user = await userRepository.getUserById(userId).getSingleOrNull();
    _user = user;
    if (user == null) {
      talker.error('user $userId is not found');
      _notify(null);
      return null;
    }
    _notify(user);
    return user;
  }

  Future<void> reloadUserStatusWithId(int userId) async {
    final user = await userRepository.getUserById(userId).getSingleOrNull();
    _user = user;
    if (user == null) {
      talker.error('user $userId is not found');
      userStream.broascastUserStatus(false);
      return;
    }
    userStream.broascastUserStatus(true);
  }

  Future<void> reloadUserInfoWithId(int userId) async {
    final user = await userRepository.getUserById(userId).getSingleOrNull();
    _user = user;
    if (user == null) {
      talker.error('user $userId is not found');
      userStream.broascastUser(null);
      return;
    }
    userStream.broascastUser(user);
  }

  void dispose() {}
}
