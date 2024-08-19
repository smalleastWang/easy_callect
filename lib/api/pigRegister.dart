import 'package:easy_collect/models/register/PigRegister.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/http/request.dart';



// 猪注册
Future registerPigAppApi(RegisterQueryModel params) async {
  return HttpUtils.post('/out/pig/registerPigAPP', query: params.toJson());
}
// 查勘对比
Future distinguishPigAppApi(DistinguishPigAppParams params) async {
  return HttpUtils.post('/out/pig/distinguishPigAPP', query: params.toJson());
}