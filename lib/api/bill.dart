import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bill.g.dart';

// 账单列表
@riverpod
Future<PageVoModel> billPage(BillPageRef ref, [Map<String, dynamic>? params]) async {
  params ??= {};
  Map<String, dynamic> res = await HttpUtils.get('/biz/bill/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}