import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'registerRecord.g.dart';

// 牛注册记录
@riverpod
Future<PageVoModel> registerRecordPage(RegisterRecordPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/register/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 猪注册记录
@riverpod
Future<PageVoModel> registerPigRecordPage(RegisterPigRecordPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/registerpig/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}