

import 'package:easy_collect/models/common/Area.dart';
import 'package:easy_collect/models/dict/Dict.dart';
import 'package:easy_collect/utils/http/request.dart';

class CommonApi {
  // 获取字典
  static Future<List<DictModel>> getDictApi() async {
    List<dynamic> data = await HttpUtils.get('/dev/dict/tree');
    List<DictModel> list = [];
    for (var item in data) {
      list.add(DictModel.fromJson(item));
    }
    return list;
  }
  // 获取地区
  static Future<List<AreaModel>> getAreaApi() async {
    List<dynamic> data = await HttpUtils.get('/sys/user/orgTreeSelector');
    List<AreaModel> list = [];
    for (var item in data) {
      list.add(AreaModel.fromJson(item));
    }
    return list;
  }
  // 获取用户列
  
}