

import 'package:easy_collect/models/dict/Dict.dart';
import 'package:easy_collect/utils/http/request.dart';

class CommonApi {
  // 获取字典
  static Future<DictModel> getDictApi() async {
    Map<String, dynamic> data = await HttpUtils.get('/dev/dict/tree');
    return DictModel.fromJson(data);
  }
  // 获取用户列
  
}