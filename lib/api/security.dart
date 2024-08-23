
import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'security.g.dart';


// 智能安防
@riverpod
Future<PageVoModel> securityPage(SecurityPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/security/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 获取摄像头数量
Future<List<Map<String, dynamic>>> getCameraListApi(String pastureId) async {
  List<dynamic> res = await HttpUtils.get('/biz/camera/getListByBldId', params: {'bldId': pastureId});
  for (var element in res) {
    element['checked'] = false;
  }
  return res.cast<Map<String, dynamic>>();
}
// 获取直播地址
Future<Map<String, dynamic>> getCameraLiveUrlApi(String deviceId) async {
  Map<String, dynamic> res = await HttpUtils.post('/biz/camera/videoGetUrl', query: {'limit': 1, 'start': 0, 'deviceId': deviceId});
  return res;
}