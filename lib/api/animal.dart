import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/animal/animal.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'animal.g.dart';

// 牛只管理
@riverpod
Future<PageVoModel> animalPage(AnimalPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/animal/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (params['current'] != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 新增/编辑牛只
Future<void> editAnimal(Animal params) async {
  if(params.id != null) {
      await HttpUtils.post('/biz/animal/edit', params: params.toJson());
      return;
  }
  await HttpUtils.post('/biz/animal/add', params: params.toJson());
}

// 删除牛只
Future<void> deleteAnimal(Map<String, dynamic> params) async {
  List<Map<String, String?>> ids = params['ids'].map((id) => {'id': id}).toList();
  await HttpUtils.post('/biz/animal/delete', params: ids);
}

// 牛只授权
Future<void> handAuth(Map<String, dynamic> params) async {
  String algorithmCode = params['algorithmCode'];
List<String> algorithmCodes = [];
  algorithmCodes.add("\"$algorithmCode\"");
  print('algorithmCodes: $algorithmCodes');
  await HttpUtils.post('/biz/animal/handAuth', params: algorithmCodes);
}

// 检测授权
Future<void> checkAuth(Map<String, dynamic> params) async {
  await HttpUtils.post('/biz/animal/checkAuth', params: {'id': params['id']}, showLoading: false);
}

// 取消授权
Future<void> cancelAuth(Map<String, dynamic> params) async {
  await HttpUtils.post('/biz/animal/cancelAuth', params: {'id': params['id']});
}