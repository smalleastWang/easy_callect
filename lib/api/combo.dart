import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/combo/Combo.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'combo.g.dart';

// combo列表
@riverpod
Future<PageVoModel> comboPage(ComboPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/combo/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (params['current'] != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}

// 新增combo
Future<void> addCombo(Combo params) async {
  await HttpUtils.post('/biz/combo/add', params: params.toJson());
}
