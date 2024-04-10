

import 'package:dio/dio.dart';
import 'package:easy_collect/models/user/Login.dart';
import 'package:easy_collect/models/user/UserInfo.dart';
import 'package:easy_collect/utils/http/request.dart';

class MyApi {
  // 刷新token
  static Future<TokenInfoModel> fetchRefreshTokenApi(Dio tokenDio, String refreshToken) async {
    Map<String, dynamic> params = {'refresh_token': refreshToken};
    
    Response<Map<String, dynamic>> res = await tokenDio.request('/refresh_token', queryParameters: params);
    Map<String, dynamic> data = res.data!;
    return TokenInfoModel.fromJson(data);
  }

  // 登录
  static Future<String> fetchLoginApi(Map<String, String> params) async {
    // params.addAll({'device': 'mobile app'});
    params.addAll({'validCode': '', 'validCodeReqNo': ''});
    String data = await HttpUtils.post('/auth/b/doLogin', params: params);
    return data;
  }
  // 获取用户信息
  static Future<UserInfoModel> getUserInfoApi() async {
    Map<String, dynamic> data = await HttpUtils.get('/auth/b/getLoginUser');
    return UserInfoModel.fromJson(data);
  }
  // 退出登录
  static Future<String> logoutApi() async {
    // params.addAll({'device': 'mobile app'});
    String data = await HttpUtils.get('/auth/b/doLogout');
    return data;
  }

}