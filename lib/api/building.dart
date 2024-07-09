import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/buildings/building.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'building.g.dart';

// 圈舍管理列表
@riverpod
Future<PageVoModel> buildingPage(BuildingPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/buildings/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (params['current'] != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 新增/编辑圈舍
Future<void> editBuilding(Map<String, dynamic> params) async {
  if(params['id'] != null) {
      await HttpUtils.post('/biz/buildings/edit', params: params);
      return;
  }
  await HttpUtils.post('/biz/buildings/add', params: params);
}

// 删除圈舍
Future<void> deleteBuilding(Map<String, dynamic> params) async {
  List<Map<String, String?>> ids = params['ids'].map((id) => {'id': id}).toList();
  await HttpUtils.post('/biz/buildings/delete', params: ids);
}

// 启用/禁用圈舍
Future<void> toggleEnableBuilding(Building params) async {
  if(params.state != "1") {
    params.state = "1";
    await HttpUtils.post('/biz/buildings/enableState', params: params.toJson());
    return;
  }
  params.state = "0";
  await HttpUtils.post('/biz/buildings/disableState', params: params.toJson());
}