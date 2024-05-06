
import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'inventory.g.dart';

// 图像盘点
@riverpod
Future<PageVoModel> imageInventory(ImageInventoryRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/scanAmount/pageApplicationPlatform', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (params['current'] != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 计数盘点
@riverpod
Future<PageVoModel> cntInventoryInfoPage(CntInventoryInfoPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/inventoryCnt/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (params['current'] != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 识别盘点
@riverpod
Future<PageVoModel> regInventoryInfoPage(RegInventoryInfoPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/inventory/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (params['current'] != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}
