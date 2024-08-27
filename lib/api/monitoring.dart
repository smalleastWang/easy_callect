import 'package:easy_collect/models/monitoring/Monitoring.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'monitoring.g.dart';

// 养殖规模
@riverpod
Future<Monitoring> getScaleInfo(GetScaleInfoRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/monitoring/scale', params: params);
  Monitoring monitoring = Monitoring.fromJson(res);
  print('res: $res');
  return monitoring;
}
// 抵押信息
@riverpod
Future<Monitoring> getMortgageInfo(GetMortgageInfoRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/monitoring/mortgage', params: params);
  Monitoring monitoring = Monitoring.fromJson(res);
  print('res: $res');
  return monitoring;
}
// 投保信息
@riverpod
Future<Monitoring> getInsureInfo(GetInsureInfoRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/monitoring/insure', params: params);
  Monitoring monitoring = Monitoring.fromJson(res);
  print('res: $res');
  return monitoring;
}
// 健康状态
@riverpod
Future<Monitoring> getHealthInfo(GetHealthInfoRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/monitoring/health', params: params);
  Monitoring monitoring = Monitoring.fromJson(res);
  print('res: $res');
  return monitoring;
}