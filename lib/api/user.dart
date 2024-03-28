

import 'package:dio/dio.dart';
import 'package:easy_collect/models/user/login.dart';

class UserApi {
  // 告警列表
  static Future<TokenInfoModel> fetchRefreshTokenApi(Dio tokenDio, String refreshToken) async {
    Map<String, dynamic> params = {'refresh_token': refreshToken};
    
    Response<Map<String, dynamic>> res = await tokenDio.request('/refresh_token', queryParameters: params);
    Map<String, dynamic> data = res.data!;
    return TokenInfoModel.fromJson(data);
  }

}