// 超时时间
class HttpOptions {
  //地址域名前缀
  static const String baseUrl = '';
  //单位时间是ms
  static const Duration connectTimeout = Duration(milliseconds: 1500);
  static const Duration receiveTimeout = Duration(milliseconds: 1500);
  static const Duration sendTimeout = Duration(milliseconds: 1500);
}