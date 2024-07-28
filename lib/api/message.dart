
// 设置盘点时间或上传时间
import 'package:easy_collect/models/message/registration.dart';
import 'package:easy_collect/utils/http/request.dart';


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
  Map<String, dynamic>? res = await  HttpUtils.post('/biz/dev/detail', params: params.toJson());
  if (res == null) return null;
  return RegistrationModel.fromJson(res);
}

