
import 'package:dio/dio.dart';
import 'package:nexpaylab/app/data/model/app_config.dart';
import 'package:nexpaylab/app/data/service/model/coin_res.dart';
import 'package:nexpaylab/app/data/service/model/user_res.dart';
import 'package:nexpaylab/app/data/service/param/login_param.dart';
import 'package:nexpaylab/app/data/service/param/register_param.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('v1/configs/list?keys={keys}')
  Future<List<ConfigItem>> getAppConfigs(@Path('keys') String keys);
  @GET('coin-market/api/v1/coins')
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
