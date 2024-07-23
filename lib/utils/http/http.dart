
import 'package:dio/dio.dart';
import 'package:easy_collect/enums/Route.dart';
import 'package:easy_collect/router/index.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';

// 辅助配置
import 'options.dart';
import 'interceptor.dart';

enum HttpMethod {
  get('get'),
  post('post'),
  delete('delete'),
  put('put'),
  patch('patch'),
  head('head');
  const HttpMethod(this.value);
  final String value;
}

class HttpRequest {
  // 单例模式使用Http类
  static final HttpRequest _instance = HttpRequest._internal();

  factory HttpRequest() => _instance;

  static late final Dio dio;

  /// 内部构造方法
  HttpRequest._internal() {
    /// 初始化dio
    BaseOptions options = BaseOptions(
        connectTimeout: HttpOptions.connectTimeout,
        receiveTimeout: HttpOptions.receiveTimeout,
        sendTimeout: HttpOptions.sendTimeout,
        baseUrl: HttpOptions.baseUrl);

    dio = Dio(options);
    Dio tokenDio = Dio(options);

    /// 添加各种拦截器
    dio.interceptors.add(ErrorInterceptor());
    dio.interceptors.add(AuthInterceptor(tokenDio: tokenDio));
    dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true, maxWidth: 100));
  }

  /// 封装request方法
  Future<T> request<T>({
    required String path, // 接口地址
    required HttpMethod method, // 请求方式
    dynamic data, // 数据
    Map<String, dynamic>? queryParameters,
    bool showLoading = true, // 加载过程
    bool showErrorMessage = true, // 是否弹出借口报错
    bool isformData = false,
  }) async {
    // 动态添加header头
    Map<String, dynamic> headers = <String, dynamic>{};
    headers["version"] = "1.0.0";

    Options options = Options(
      method: method.value,
      headers: headers,
    );
    if (isformData) options.contentType = 'multipart/form-data';

    try {
      if (showLoading) {
        EasyLoading.show();
      }
      Response response = await HttpRequest.dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      if (path.contains("doLogout")) {
        EasyLoading.showToast('退出登录成功');
        return response.data?['data'];
      }
      if (response.data['code'] == 401) {
        routeKey.currentContext?.go(RouteEnum.login.path);
        EasyLoading.showToast('登录已过期，请重新登录');
        throw Exception(response.data['msg']);
      }
      EasyLoading.showToast(response.data['msg']);
      throw Exception(response.data['msg']);
    } on
DioException catch (error) {
      if (showErrorMessage && error.message != null) {
        EasyLoading.showToast(error.message!);
      }
    } finally {
      if (showLoading) {
        EasyLoading.dismiss();
      }
    }
    if (T is List) return [] as T;
    if (T is Map) return {} as T;
    if (T is String) return '' as T;
    return null as T;
  }
}