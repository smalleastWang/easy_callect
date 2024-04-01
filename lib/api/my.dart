

import 'package:dio/dio.dart';
import 'package:easy_collect/models/user/Login.dart';
import 'package:easy_collect/utils/http/request.dart';

class MyApi {
  // 告警列表
  static Future<TokenInfoModel> fetchRefreshTokenApi(Dio tokenDio, String refreshToken) async {
    Map<String, dynamic> params = {'refresh_token': refreshToken};
    
    Response<Map<String, dynamic>> res = await tokenDio.request('/refresh_token', queryParameters: params);
    Map<String, dynamic> data = res.data!;
    return TokenInfoModel.fromJson(data);
  }

  // 告警列表
  static Future<String> fetchLoginApi(Map<String, String> params) async {
    // params.addAll({'device': 'mobile app'});
    params.addAll({'validCode': '', 'validCodeReqNo': ''});
    String data = await HttpUtils.post('/auth/b/doLogin', params: params);
    return data;
  }
  // 告警列表
  static Future<String> fetchUserInfoApi(params) async {
    String data = await HttpUtils.get('/auth/b/getLoginUser', params: params);
    return data;
  }

}