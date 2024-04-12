import 'package:easy_collect/models/index.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register.g.dart';

class RegisterApi {
  // 上传至算法文件服务器图片
  static Future<String> cattleApp(RegisterQueryModel params) async {
    CommonMap data = await HttpUtils.post('/out/v1/registerCattleAPP', params: params.toJson());
    return 'list';
  } 
}

@riverpod
Future<List<EnclosureModel>> enclosureList(EnclosureListRef ref) async {
  List<dynamic> res = await HttpUtils.post('/out/v1/getOrgAndBuildings');
  List<EnclosureModel> list = [];
  for (var item in res) {
    list.add(EnclosureModel.fromJson(item));
  }
  return list;
}