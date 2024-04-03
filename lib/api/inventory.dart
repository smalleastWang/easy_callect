
import 'package:easy_collect/models/Inventory/Image.dart';
import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/utils/http/request.dart';

class InventoryApi {
  // 获取用户信息
  static Future<PageVoModel> getImageApi(Map<String, dynamic> params) async {

    Map<String, dynamic> data = await HttpUtils.get('/biz/scanAmount/pageApplicationPlatform', params: params);
    return PageVoModel.fromJson(data);
  }
}