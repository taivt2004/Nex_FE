
import 'package:dio/dio.dart';
import 'package:nexpaylab/app/data/model/app_config.dart';
import 'package:nexpaylab/app/data/service/model/coin_res.dart';
import 'package:nexpaylab/app/data/service/model/user_res.dart';
import 'package:nexpaylab/app/data/service/param/login_req.dart';
import 'package:nexpaylab/app/data/service/param/register_req.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('v1/configs/list?keys={keys}')
  Future<List<ConfigItemRes>> getAppConfigs(@Path('keys') String keys);
  @GET('coin-market/api/v1/coins')
  Future<CoinRes> getCoins(
      @Query('page') int page,
      @Query('limit') int limit,
      );
    
  @POST('v1/users/login')
  Future<UserRes> login(@Body() LoginReq param);
  @POST('v1/users/register')
  Future<UserRes> register(@Body() RegisterReq param);
  @POST('v1/users/logout')
  Future<int> logout();
}
