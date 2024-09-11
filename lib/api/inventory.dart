
import 'package:easy_collect/models/Inventory/HistoryData.dart';
import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'inventory.g.dart';

// 图像盘点
@riverpod
Future<PageVoModel> imageInventory(ImageInventoryRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/scanAmount/pageApplicationPlatform', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 计数盘点
@riverpod
Future<PageVoModel> cntInventoryInfoPage(CntInventoryInfoPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/inventoryCnt/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 计数盘点明细
@riverpod
Future<List<dynamic>> inventoryCntDetail(InventoryCntDetailRef ref, Map<String, dynamic> params) async {
  List<dynamic> inventoryCntDetailList = await HttpUtils.post('/biz/inventoryCnt/detail', params: params, showLoading: false);
  return inventoryCntDetailList;
}

// 手工盘点
Future inventoryManual(Map<String, dynamic> params) async {
  return HttpUtils.post('/biz/inventoryCnt/manual', params: params);
}

// 识别盘点
@riverpod
Future<PageVoModel> regInventoryInfoPage(RegInventoryInfoPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/inventory/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 识别盘点-设置盘点时间-牧场列表
@riverpod
Future<PageVoModel> inventoryOrgListApi(InventoryOrgListApiRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/inventory/orgList', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  for (var element in data.records) {
    Map<String, dynamic> map = {'selected': false};
    element.addAll(map);
  }
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 识别盘点-历史数据列表
@riverpod
Future<PageVoModel> inventoryHistoryDataListApi(InventoryHistoryDataListApiRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/inventory/historyDetail', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 设置盘点时间或上传时间
Future setInventoryTimeApi(Map<String, dynamic> params) async {
  return HttpUtils.post('/biz/inventory/editTime', params: params);
}

// 设置盘点-历史数据
Future<InventoryHistoryDataVo> inventoryHistoryDataApi(Map<String, dynamic> params) async {
  Map<String, dynamic> data = await HttpUtils.post('/biz/inventory/history', params: params);
  return InventoryHistoryDataVo.fromJson(data);
}
