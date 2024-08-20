import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/animal/pigAnimal.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pigAnimal.g.dart';

// 猪管理
@riverpod
Future<PageVoModel> pigAnimalPage(PigAnimalPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/animalpig/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 新增/编辑猪
Future<void> editPigAnimal(PigAnimal params) async {
  if(params.id != null) {
      await HttpUtils.post('/biz/animalpig/edit', params: params.toJson());
      return;
  }
  await HttpUtils.post('/biz/animalpig/add', params: params.toJson());
}

// 删除猪
Future<void> deletePigAnimal(Map<String, dynamic> params) async {
  List<Map<String, String?>> ids = params['ids'].map((id) => {'id': id}).toList();
  await HttpUtils.post('/biz/animalpig/delete', params: ids);
}

// 猪授权
Future<void> handAuth(Map<String, dynamic> params) async {
  String algorithmCode = params['algorithmCode'];
List<String> algorithmCodes = [];
  algorithmCodes.add("\"$algorithmCode\"");
  print('algorithmCodes: $algorithmCodes');
  await HttpUtils.post('/biz/animalpig/handAuth', params: algorithmCodes);
}

// 检测授权
Future<void> checkAuth(Map<String, dynamic> params) async {
  await HttpUtils.post('/biz/animalpig/checkAuth', params: {'id': params['id']}, showLoading: false);
}

// 取消授权
Future<void> cancelAuth(Map<String, dynamic> params) async {
  await HttpUtils.post('/biz/animalpig/cancelAuth', params: {'id': params['id']});
}