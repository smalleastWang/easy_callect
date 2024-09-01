
import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'milksidentify.g.dart';

// 在位识别
@riverpod
Future<PageVoModel> milksidentifyPage(MilksidentifyPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/milksidentify/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 新增/编辑在位识别
Future<void> addMilksidentify(Map<String, dynamic> params) async {
  if(params['id'] != null) {
      await HttpUtils.post('/biz/milksidentify/edit', params: params);
      return;
  }
  await HttpUtils.post('/biz/milksidentify/add', params: params);
}