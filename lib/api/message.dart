
// 设置盘点时间或上传时间
import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/message/JPushRegistration.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'message.g.dart';


/// 添加APP设备注册表
/// orgId String
/// registrationId String
Future addRegistrationApi(RegistrationModel params) async {
  return HttpUtils.post('/biz/dev/add', params: params.toJson());
}

/// 获取APP设备注册表详情
/// registrationId String 或
/// id Sting
Future<RegistrationModel?> getRegistrationInfoApi(RegistrationModel params) async {
  Map<String, dynamic>? res = await  HttpUtils.get('/biz/dev/detail', params: params.toJson());
  if (res == null) return null;
  return RegistrationModel.fromJson(res);
}


/// 系统消息列表
@riverpod
Future<PageVoModel> newMessagePage(NewMessagePageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/dev/message/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

