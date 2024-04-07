import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_collect/api/my.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/enums/StorageKey.dart';
import 'package:easy_collect/models/user/Login.dart';
import 'package:easy_collect/router/index.dart';
import 'package:easy_collect/utils/global.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    /// dio默认的错误实例，如果是没有网络，只能得到一个未知错误，无法精准的得知是否是无网络的情况
    /// 这里对于断网的情况，给一个特殊的code和msg
    if (err.type == DioExceptionType.unknown) {
      final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
        EasyLoading.showToast('设备没有网络，请检查网络连接');
      }
    }
    handler.next(err);
  }
}

// 
class AuthInterceptor extends QueuedInterceptor {
  final Dio tokenDio;
 
  AuthInterceptor({required this.tokenDio});

  Future<String> refreshToken() async {
    try {
      final String? refreshToken = SharedPreferencesManager().getString(StorageKeyEnum.refreshToken.value);
      if (refreshToken != null) {
        TokenInfoModel tokenInfo =  await MyApi.fetchRefreshTokenApi(tokenDio, refreshToken);
        SharedPreferencesManager().setString(StorageKeyEnum.refreshToken.value, tokenInfo.refreshToken);
        await SharedPreferencesManager().setString(StorageKeyEnum.token.value, tokenInfo.token);
        return tokenInfo.token;
      }
      throw Exception('refreshToken 为空！');
    } catch (e) {
      throw Exception('获取Token失败！');
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? token = SharedPreferencesManager().getString(StorageKeyEnum.token.value);
    if (token != null || options.path.contains('/auth/b/doLogin')) {
      options.headers['Token'] = token;
    } else {
      navigatorKey.currentContext?.go(RouteEnum.login.value);
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      navigatorKey.currentContext?.go(RouteEnum.login.value);
      // await refreshToken();
      handler.next(err);
    }
    super.onError(err, handler);
  }
}
