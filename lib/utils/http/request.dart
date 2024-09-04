import 'package:dio/dio.dart';

import 'http.dart';

/// 调用底层的request，重新提供get，post等方便方法

class HttpUtils {
  static HttpRequest httpRequest = HttpRequest();

  /// get
  static Future get(String path, {
    Map<String, dynamic>? params,
    bool showLoading = false,
    bool showErrorMessage = true,
    bool isSourceData = false
  }) {
    return httpRequest.request(
      path: path,
      method: HttpMethod.get,
      queryParameters: params,
      showLoading: showLoading,
      showErrorMessage: showErrorMessage,
      isSourceData: isSourceData
    );
  }

  /// post
  static Future post(String path, {
    dynamic params,
    dynamic query, 
    bool showLoading = true,
    bool showErrorMessage = true,
    bool isformData = false,
    bool isSourceData = false
  }) {
    return httpRequest.request(
      path: path,
      method: HttpMethod.post,
      data: params,
      queryParameters: query,
      showLoading: showLoading,
      showErrorMessage: showErrorMessage,
      isformData: isformData,
      isSourceData: isSourceData
    );
  }
  /// 下载
  static Future download(String path, String savePath, {
      ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      bool deleteOnError = true,
      String lengthHeader = Headers.contentLengthHeader,
      Object? data,
      Options? options,
    }) {
    return httpRequest.download(
      path,
      savePath, 
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      lengthHeader: lengthHeader,
      data: data,
      options: options,
    );
  }
  
}