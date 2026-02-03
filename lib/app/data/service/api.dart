
import 'package:dio/dio.dart';
import 'package:nexpaylab/app/data/model/auth/auth_res.dart';
import 'package:nexpaylab/app/data/model/auth/login_req.dart';
import 'package:nexpaylab/app/data/model/auth/register_req.dart';
import 'package:nexpaylab/app/data/model/base/base_res.dart';
import 'package:nexpaylab/app/data/model/coin/coin_res.dart';
import 'package:nexpaylab/app/data/model/common/config_res.dart';
import 'package:retrofit/retrofit.dart';

part 'api.g.dart';

@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET('configuration/api/v1/business-configs')
  Future<BaseRes<ConfigRes>> getAppConfigs(@Query('keys') String keys);
    
  @GET('coin-market/api/v1/coins')
  Future<BaseRes<List<CoinRes>>> getCoins(
      @Query('page') int page,
      @Query('limit') int limit,
      );
    
  @POST('v1/users/login')
  Future<AuthRes> login(@Body() LoginReq param);
  @POST('v1/users/register')
  Future<AuthRes> register(@Body() RegisterReq param);
  @POST('v1/users/logout')
  Future<int> logout();
}
