import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/aibox/aibox.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'aibox.g.dart';

// aibox列表
@riverpod
Future<PageVoModel> aiboxPage(AiboxPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/aibox/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (params['current'] != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 新增/编辑aibox
Future<void> editAIBox(Map<String, dynamic> params) async {
  if(params['id'] != null) {
      await HttpUtils.post('/biz/aibox/edit', params: params);
      return;
  }
  await HttpUtils.post('/biz/aibox/add', params: params);
}
