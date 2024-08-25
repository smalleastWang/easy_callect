import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'email.g.dart';

// email列表
@riverpod
Future<PageVoModel> emailPage(EmailPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/email/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 新增email
Future<void> addEmail(Map<String, dynamic> params) async {
  if(params['id'] != null) {
      await HttpUtils.post('/biz/email/edit', params: params);
      return;
  }
  await HttpUtils.post('/biz/email/add', params: params);
}

// 删除email
Future<void> delEmail(List<Map<String, String?>> params) async {
  await HttpUtils.post('/biz/email/delete', params: params);
}