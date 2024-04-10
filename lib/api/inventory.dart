
import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'inventory.g.dart';

class InventoryApi {
  // 图像盘点
  static Future<PageVoModel> getImageApi(Map<String, dynamic> params) async {
    Map<String, dynamic> data = await HttpUtils.get('/biz/scanAmount/pageApplicationPlatform', params: params);
    return PageVoModel.fromJson(data);
  }
}

@riverpod
Future<PageVoModel> imageInventory(ImageInventoryRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> data = await HttpUtils.get('/biz/scanAmount/pageApplicationPlatform', params: params);
  return PageVoModel.fromJson(data);
}

