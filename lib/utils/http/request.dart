import 'http.dart';

/// 调用底层的request，重新提供get，post等方便方法

class HttpUtils {
  static HttpRequest httpRequest = HttpRequest();

  /// get
  static Future get(String path, {
    Map<String, dynamic>? params,
    bool showLoading = true,
    bool showErrorMessage = true,
  }) {
    return httpRequest.request(
      path: path,
      method: HttpMethod.get,
      queryParameters: params,
      showLoading: showLoading,
      showErrorMessage: showErrorMessage,
    );
  }

  /// post
  static Future post(String path, {
    dynamic params,
    bool showLoading = true,
    bool showErrorMessage = true,
  }) {
    return httpRequest.request(
      path: path,
      method: HttpMethod.post,
      data: params,
      showLoading: showLoading,
      showErrorMessage: showErrorMessage,
    );
  }
}