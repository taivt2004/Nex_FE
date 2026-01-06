import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:nexpaylab/app/core/data/model/app.config.dart';
import 'package:nexpaylab/app/core/data/model/user.dart';
import 'package:nexpaylab/app/core/data/service/model/coin.res.dart';
import 'package:nexpaylab/app/core/data/service/model/common.res.dart';
import 'package:nexpaylab/app/core/data/service/model/user.res.dart';
import 'package:nexpaylab/app/core/data/service/param/login.param.dart';
import 'package:nexpaylab/app/core/data/service/param/register.param.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('v1/configs/list?keys={keys}')
  Future<List<ConfigItem>> getAppConfigs(@Path('keys') String keys);
  @GET('coins')
  Future<CoinResponse> getCoins(
      @Query('page') int page,
      @Query('limit') int limit,
      );
    
  @POST('v1/users/login')
  Future<UserResponse> login(@Body() LoginParam param);
  @POST('v1/users/register')
  Future<UserResponse> register(@Body() RegisterParam param);
  @POST('v1/users/logout')
  Future<int> logout();
}
