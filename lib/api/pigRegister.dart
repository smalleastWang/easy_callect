import 'package:easy_collect/models/register/PigRegister.dart';
import 'package:easy_collect/utils/http/request.dart';



// 猪注册
Future registerPigAppApi(PigRegisterParams params) async {
  return HttpUtils.post('/out/pig/registerPigAPP', query: params.toJson());
}
// 猪识别信息
Future distinguishPigAppApi(DistinguishPigAppParams params) async {
  return HttpUtils.post('/out/pig/distinguishPigAPP', query: params.toJson());
}