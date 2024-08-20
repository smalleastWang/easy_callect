import 'package:easy_collect/models/PageVo.dart';
import 'package:easy_collect/models/register/index.dart';
import 'package:easy_collect/utils/http/request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'precisionBreeding.g.dart';

@riverpod
Future<List<EnclosureModel>> weightInfoTree(WeightInfoTreeRef ref) async {
  List<dynamic> res = await HttpUtils.get('/biz/buildings/buildingTree');
  List<EnclosureModel> list = [];
  for (var item in res) {
    list.add(EnclosureModel.fromJson(item));
  }
  return list;
}

@riverpod
Future<PageVoModel> weightInfoPage(WeightInfoPageRef ref, Map<String, dynamic> params) async {
  Map<String, dynamic> res = await HttpUtils.get('/biz/performance/page', params: params);
  PageVoModel data = PageVoModel.fromJson(res);
  if (data.current != 1 && ref.state.hasValue) {
    data.records.insertAll(0, ref.state.value!.records);
  }
  return data;
}