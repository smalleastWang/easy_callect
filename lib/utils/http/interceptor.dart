import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_collect/api/user.dart';
import 'package:easy_collect/models/user/login.dart';
import 'package:easy_collect/utils/http/http.dart';
import 'package:easy_collect/utils/storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FailRequest {
  RequestOptions options;
  ErrorInterceptorHandler handlers;
  FailRequest(this.options, this.handlers);
}

List<FailRequest> failRequests  = [];
bool _refreshingToken = false;

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
      final String? refreshToken = SharedPreferencesManager().getString('refreshToken');
      if (refreshToken != null) {
        TokenInfoModel tokenInfo =  await UserApi.fetchRefreshTokenApi(tokenDio, refreshToken);
        SharedPreferencesManager().setString('refreshToken', tokenInfo.refreshToken);
        await SharedPreferencesManager().setString('token', tokenInfo.token);
        return tokenInfo.token;
      }
      throw Exception('refreshToken 为空！');
    } catch (e) {
      throw Exception('获取Token失败！');
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String? token = SharedPreferencesManager().getString('token');
    if (token != null && !options.path.contains('/auth/oauth/token')) {
      if (!options.path.contains('/auth/oauth/token')) {
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        // TODO: 跳转去登陆
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await refreshToken();
      handler.next(err);
    }
    super.onError(err, handler);
  }
}
