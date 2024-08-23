import 'package:easy_collect/models/monitoring/Monitoring.dart';
import 'package:easy_collect/utils/http/request.dart';

class MonitoringApi {
  // 养殖规模
  static Future<Monitoring> geScaleInfo(Map<String, dynamic> params) async {
    Map<String, dynamic> res = await HttpUtils.get('/biz/monitoring/scale', params: params);
    Monitoring monitoring = Monitoring.fromJson(res);
    print('res: $res');
    return monitoring;
  }
  // 抵押信息
  static Future<Monitoring> getMortgageInfo(Map<String, dynamic> params) async {
    Map<String, dynamic> res = await HttpUtils.get('/biz/monitoring/mortgage', params: params);
    Monitoring monitoring = Monitoring.fromJson(res);
    print('res: $res');
    return monitoring;
  }
  // 投保信息
  static Future<Monitoring> getInsureInfo(Map<String, dynamic> params) async {
    Map<String, dynamic> res = await HttpUtils.get('/biz/monitoring/insure', params: params);
    Monitoring monitoring = Monitoring.fromJson(res);
    print('res: $res');
    return monitoring;
  }
  // 健康状态
  static Future<Monitoring> getHealthInfo(Map<String, dynamic> params) async {
    Map<String, dynamic> res = await HttpUtils.get('/biz/monitoring/health', params: params);
    Monitoring monitoring = Monitoring.fromJson(res);
    print('res: $res');
    return monitoring;
  }
}