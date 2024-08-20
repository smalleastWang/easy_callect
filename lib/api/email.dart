import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/email/email.dart';
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
Future<void> addEmail(Email params) async {
  await HttpUtils.post('/biz/email/add', params: params.toJson());
}
